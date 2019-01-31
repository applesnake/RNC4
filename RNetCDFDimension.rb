require 'FFINetCDF'
require 'RNCUtil'
require 'RNCDelegate'

class RNetCDFDimension
  attr_reader :ncid, :gid, :name
  def initialize(ncid, gid, name)
    @ncid = ncid
    @gid = gid
    @name = name
    return self
  end
  def RNetCDFDimension=(len)
    self.def(len)
  end
  def def(len)
    gid = @gid ? @gid : @ncid
    FFINetCDF.nc_redef(gid)
    RNCUtil.withFFIVariables(did:[:int,1]) do | did |
      ncerr(FFINetCDF.nc_def_dim(gid, @name, len, did) { FFINetCDF.nc_enddef(gid) },
            __FILE__, __LINE__)
      return self
    end
  end
end
