require 'FFINetCDF'
require 'RNetCDFGroup'

class Array
  def cond(**args)
    args.each do | k, p |
      if self.include?(k) and k != :t and k != :op then
        if p.class == Proc then
          p.call
        else
          if args[:op] then
            args[:op].call(p)
          else
            return p
          end
        end
      end
    end
    args[:t].class == Proc ? args[:t].call : args[:t]
  end
end

class RNetCDF < RNetCDFGroup
  attr_reader :ncid, :name
  include ObjectSpace
  def initialize
    @ncid = nil
    @name = "/"
    define_finalizer(self,
                     proc {| o | self.close })
    return self
  end
  def close
    return self if not @ncid or @ncid < 0 
    FFINetCDF.nc_close(@ncid);
    @ncid = nil
    return self
  end
  def open(fpath, *args) # :overwrite, :readonly, :readwrite
    if File.exists?(fpath) then
      flags = FFINetCDF::NC_NETCDF4
      args.cond(
        overwrite:  proc {flags = flags | FFINetCDF::NC_CLOBBER},
        readonly:   proc {flags = flags | FFINetCDF::NC_NOWRITE},
        readwrite:  proc {flags = flags | FFINetCDF::NC_WRITE},
        t:          proc {flags = flags | FFINetCDF::NC_NOWRITE},
      )
      RNCUtil.withFFIVariables(ncid: [:int, 1]) do | ncid |
        if ncerr(FFINetCDF.nc_open(fpath, flags, ncid), "#{__FILE__}:#{__LINE__}") then
          return nil
        end
        @ncid = ncid.read_int
      end
      return self
    else
      return nil if args.include?(:readonly)
      RNCUtil.withFFIVariables(ncid:[:int, 1]) do | ncid | 
        flags = FFINetCDF::NC_NETCDF4 | FFINetCDF::NC_WRITE
        args.cond(overwrite:  proc {flags = flags | FFINetCDF::NC_CLOBBER},
                  t:          proc {flags = flags | FFINetCDF::NC_NOCLOBBER})
        return nil if ncerr(FFINetCDF.nc_create(fpath, flags, ncid), "#{__FILE__}:#{__LINE__}")
        @ncid = ncid.read_int
      end
      return self
    end
  end
  def create(file, like: nil)
  end
  def group(name = nil)
    if not name then
      return RNCDelegate.new(@ncid, nil, :group)
    else
      return RNetCDFGroup.new(@ncid, name)
    end
  end
  def variable(name = nil)
    if not name then
      return RNCDelegate.new(@ncid, nil, :variable)
    else
      return RNetCDFVariable.new(@ncid, name)
    end
  end
  def attribute(name = nil)
    if not name then
      return RNCDelegate.new(@ncid, nil, :attribute)
    else
      return RNetCDFAttribute.new(@ncid, nil, name)
    end
  end
end
