require 'FFINetCDF'
require 'RNCUtil'
require 'RNCDelegate'
require 'RNetCDFAttribute'


class RNetCDFVariable
  attr_reader :ncid, :vid, :name
  def initialize(ncid, name)
    @ncid = ncid
    @vid = RNCUtil.variableIdForName(name, ncid)
    @name = name
    @@nat_nct = {
      Numo::Int8 => FFINetCDF::NC_CHAR,
      Numo::Int16 => FFINetCDF::NC_SHORT,
      Numo::Int32 => FFINetCDF::NC_INT,
      Numo::Int64 => FFINetCDF::NC_INT64,
      Numo::UInt8 => FFINetCDF::NC_UBYTE,
      Numo::UInt16 => FFINetCDF::NC_USHORT,
      Numo::UInt32 => FFINetCDF::NC_UINT,
      Numo::UInt64 => FFINetCDF::NC_UINT64,
      Numo::SFloat => FFINetCDF::NC_FLOAT,
      Numo::DFloat => FFINetCDF::NC_DOUBLE
    }
    return self
  end
  def attribute
    return RNCDelegate.new(@ncid, @vid, :attribute)
  end
  def to_narray
    return nil if not @vid
    return RNCUtil.readVariable(vid, ncid)
  end
  alias :get :to_narray
  def checkAndValidDimensions(dims)
    RNCUtil.withFFIVariables(ndims:[:int,1],
                             dimids:[:int, 512],
                             name:[:char, 4096],
                             dimlen:[:ulong_long, 1]) do
      | ndims, dimids, name, dimlen |
      r = FFINetCDF.nc_inq_dimids(@ncid, ndims, dimids, 0)
      return nil if ncerr(r, __FILE__, __LINE__)
      out = {}
      
      for i in 0...ndims.read_int do
        r = FFINetCDF.nc_inq_dimname(@ncid, dimids.get_int32(i*4), name)
        return nil if ncerr(r, __FILE__, __LINE__)
        t = dims.index(name.read_string)
        next if not t
        r = FFINetCDF.nc_inq_dimlen(@ncid, dimids.get_int32(i*4), dimlen)
        return nil if ncerr(r, __FILE__, __LINE__)
        out[name.read_string] = {id: dimids.get_int32(i*4),
                                 len: dimlen.read_uint64}
      end
      return out
    end
  end
  def put(narray, dims, fillValue: nil)
    return nil if not narray
    if narray.ndim != dims.length then
      STDERR.puts "Input narray object dim count is not match given dims"
      return nil
    end
    dim_info = checkAndValidDimensions(dims)
    if not dim_info or dim_info.length <= 0 then
      STDERR.puts "Some dimensions is missing for variable '#{@name}'."
      return nil
    end
    for i in 0...dims.length do
      dname = dims[i]
      if narray.shape[i] != dim_info[dname][:len] then
        STDERR.puts "Dimension length not match: #{dim_info[dname][:name]} #{dim_info[dname][:len]} != Array[#{i}]:#{narray.shape[i]}"
        return nil
      end
    end
    RNCUtil.withFFIVariables(vid:[:int, 1],
                             dimids:[:int, 512]) do | vid, dimids |
      FFINetCDF.nc_redef(@ncid)
      xtype = @@nat_nct[narray.class]
      return nil if not xtype

      for i in 0...dims.length do
        dimids.put_int32(i*4, dim_info[dims[i]][:id])
      end
      
      return nil if ncerr(FFINetCDF.nc_def_var(@ncid, @name,
                                               xtype,
                                               narray.ndim,
                                               dimids,
                                               vid),__FILE__, __LINE__,
                          on_error: proc {
                            FFINetCDF.nc_enddef(@ncid)
                          })
      
      @vid = vid.read_int
      FFINetCDF.nc_def_var_deflate(@ncid, @vid, 0, 1, 6)
      if fillValue then
        self.attribute._FillValue = fillValue
      end
      return nil if ncerr(FFINetCDF.nc_put_var(@ncid, @vid, narray.to_binary) {
                            FFINetCDF.nc_enddef(@ncid)},
                          __FILE__, __LINE__)
    end
    return self
  end
  def apply(&block)
    block.call(self) if block
  end
  def method_missing(sym, *args, &block)
    ss = sym.to_s
    if ss[-1] = "=" then
      obj =  attribute(ss[0,ss.length-1])
      op = "RNetCDFAttribute=".to_sym
      return obj.send(op, *args, &block)
    else
      return attribute(ss)
    end
    return nil
  end
  def def(dims, vtype)
    require 'RNCUtilV1'
    FFINetCDF.nc_redef(@ncid)
    if not RNCUtilV1.createVar(@ncid, @name, vtype, dims)
      FFINetCDF.nc_enddef(@ncid)
      return nil 
    end
    FFINetCDF.nc_enddef(@ncid)
    return self
  end
  def attributes
    return {} if not @ncid and not @vid
    RNCUtil.getAllAttributes(@ncid, @vid)
  end
end
