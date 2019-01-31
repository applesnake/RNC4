require 'FFINetCDF'
require 'ffi'
require 'numo/narray'

module RNCUtil
  FNC = FFINetCDF  
  def RNCUtil.cond(src_value, *args, **kargs, &block)
    src_value = src_value.class != Symbol ? src_value.to_s.to_sym : src_value
    kargs.each do | k, p |
      if k.class != Proc then
        if(src_value == k) and k != :t then
          return p.call if p.class == Proc
        end
      else
        if(src_value == k.call) then
          return p.call if p.class == Proc
        end
      end
    end
    return kargs[:t].call if kargs[:t].class == Proc
  end
  def RNCUtil.withFFIVariables(**args, &block)
    ffi_vars = []
    for k,v in args do
      fv = FFI::MemoryPointer.new(v[0], v[1])
      ffi_vars << fv
    end
    return block.call(*ffi_vars)
  end
  def RNCUtil.groupIdForName(name, ncid)
    withFFIVariables(gid:[:int, 1]) do | gid |
      if name != "/" and name[0] == "/" then
        name = name[1, name.length]
      end
      r = FNC.nc_inq_grp_ncid(ncid, name, gid)
      return nil if ncerr(r, __FILE__, __LINE__)
      gid.read_int
    end
  end
  def RNCUtil.variableIdForName(name, ncid)
    withFFIVariables(vid:[:int, 1]) do | vid |
      r = FNC.nc_inq_varid(ncid, name, vid)
      return nil if ncerr(r, __FILE__, __LINE__) # , on_error: proc{ puts "[W]#{__callee__} > Variable '#{name}' not found"})
      vid.read_int
    end
  end
  def RNCUtil.createGroup(name,ncid)
    withFFIVariables(gid:[:int, 1]) do | gid |
      name = name[1,name.length] if name != "/" and name[0] == "/"
      FFINetCDF.nc_redef(ncid)
      return nil if ncerr(FNC.nc_def_grp(ncid, name, gid)) { FFINetCDF.nc_enddef(ncid) }
      return gid.read_int
    end
  end
  def RNCUtil.dimensionInfo(vid, ncid)
    withFFIVariables(ndim:[:int, 1], dimids:[:int, 32],
                     name:[:char, 1024], dimlen:[:ulong, 1]) do | ndim, dimids, name , dimlen|
      next nil if ncerr(FFINetCDF.nc_inq_varndims(ncid, vid, ndim), __FILE__, __LINE__)
      next nil if ncerr(FFINetCDF.nc_inq_vardimid(ncid, vid, dimids), __FILE__, __LINE__)
      out = []
      for i in 0...ndim.read_int do
        break if ncerr(FFINetCDF.nc_inq_dimname(ncid, dimids.get_int32(i*4), name), __FILE__, __LINE__)
        break if ncerr(FFINetCDF.nc_inq_dimlen(ncid, dimids.get_int32(i*4), dimlen), __FILE__, __LINE__)
        out << {name: name.read_string, did: dimids.get_int32(i*4), len: dimlen.read_uint32}
      end
      out
    end
  end
  def RNCUtil.variableType(vid, ncid)
    withFFIVariables(xtype:[:int, 1]) do | xtype |
      return nil if ncerr(FFINetCDF.nc_inq_vartype(ncid, vid, xtype), __FILE__, __LINE__)
      next xtype.read_int
    end
  end
  def RNCUtil.readVariable(vid, ncid)
    dim_info = dimensionInfo(vid, ncid)
    return nil if not dim_info or dim_info.length == 0
    xtype = variableType(vid, ncid)
    return nil if not xtype
    shape = []
    value_count = 1
    dim_info.each do | di |
      shape << di[:len]
      value_count *= di[:len]
    end
    na = nil
    nt = nil
    case xtype
    when FFINetCDF::NC_CHAR
      withFFIVariables(str:[:char, di[0][:len] + 1]) do | str |
        next nil if ncerr(FFINetCDF.nc_get_var_text(ncid, vid, str))
        next str.read_string
      end
    else
      bytes_cnt = 0
      case xtype
      when FFINetCDF::NC_BYTE
        nt = proc do | str, shape|
          Numo::Int8.from_binary(str, shape)
        end
        bytes_cnt = value_count
      when FFINetCDF::NC_SHORT
        nt = proc do | str, shape|
          Numo::Int16.from_binary(str, shape)
        end
        bytes_cnt = value_count * 2
      when FFINetCDF::NC_INT
        nt = proc do | str, shape|
          Numo::Int32.from_binary(str, shape)
        end
        bytes_cnt = value_count * 4
      when FFINetCDF::NC_FLOAT
        nt = proc do | str, shape|
          Numo::SFloat.from_binary(str, shape)
        end
        bytes_cnt = value_count * 4
      when FFINetCDF::NC_DOUBLE
        nt = proc do | str, shape|
          Numo::DFloat.from_binary(str, shape)
        end
        bytes_cnt = value_count * 8
      when FFINetCDF::NC_UBYTE
        nt = proc do | str, shape|
          Numo::UInt8.from_binary(str, shape)
        end
        bytes_cnt = value_count
      when FFINetCDF::NC_USHORT
        nt = proc do | str, shape|
          Numo::UInt16.from_binary(str, shape)
        end
        bytes_cnt = value_count * 2
      when FFINetCDF::NC_UINT
        nt = proc do | str, shape|
          Numo::UInt32.from_binary(str, shape)
        end
        bytes_cnt = value_count * 4
      when FFINetCDF::NC_INT64
        nt = proc do | str, shape|
          Numo::Int64.from_binary(str, shape)
        end
        bytes_cnt = value_count * 8
      when FFINetCDF::NC_UINT64
        nt = proc do | str, shape|
          Numo::UInt64.from_binary(str, shape)
        end
        bytes_cnt = value_count * 8
      else
        STDERR.puts "Unsupported value class: #{xtype}"
        return nil
      end
      #puts shape.to_s
      withFFIVariables(buf:[:char, bytes_cnt]) do | buf |
        next nil if ncerr(FFINetCDF.nc_get_var(ncid, vid, buf), __FILE__, __LINE__)
        bytes = buf.get_bytes(0, bytes_cnt)
        na = nt.call(bytes, shape)
      end
    end
    na
  end
  def RNCUtil.dumpNCSchema(ncid)
    require 'RNCUtilV1'
    return RNCUtilV1.dumpNCSchema(ncid)
  end
  def RNCUtil.createNewFileWithSchema(schema, nc)
    schema.each do | grp_name, v|
      grp_name = "/" if grp_name == ""
      gp = nc.group(grp_name)
      v[:attributes].each do | name, va |
        gp.attribute(name).def(va)
      end
      v[:dimensions].each do | name, va |
        gp.dimension(name).def(va)
      end
      v[:variables].each do | name , va |
        dim_names = va[:dimensions].map do | i | i[0] end
        gp.variable(name).def(dim_names, va[:type])
      end
    end
  end
  def RNCUtil.getAllAttributes(ncid, vid)
    if not vid then
      vid = FFINetCDF::NC_GLOBAL
      withFFIVariables(natts:[:int, 1], name:[:char,1024]) do
        | natts, name |
        return nil if ncerr(FFINetCDF.nc_inq_natts(ncid, natts),
                            __FILE__, __LINE__)
        objs = []
        for i in 0...natts.read_int do
          return nil if ncerr(FFINetCDF.nc_inq_attname(ncid, vid, i, name),
                              __FILE__, __LINE__)
          objs << RNetCDFAttribute.new(ncid, vid, name.read_string)
        end
        objs
      end
    else
      withFFIVariables(natts:[:int, 1], name:[:char,1024]) do
        | natts |
        return nil if ncerr(FFINetCDF.nc_inq_varnatts(ncid, vid, natts),
                            __FILE__, __LINE__)
        objs = []
        for i in 0...natts.read_int do
          return nil if ncerr(FFINetCDF.nc_inq_attname(ncid, vid, i, name),
                              __FILE__, __LINE__)
          objs << RNetCDFAttribute.new(ncid, vid, name.read_string)
        end
        objs
      end
    end
  end

  def RNCUtil.getAllGroups(ncid)
    withFFIVariables(num:[:int, 1], gids:[:int,1024],
                     name:[:char,1024]) do
      | num, gids, name |
      next nil if ncerr(FFINetCDF.nc_inq_grps(ncid, num, gids),
                          __FILE__, __LINE__)
      objs = []
      for i in 0...num.read_int do
        if not ncerr(FFINetCDF.nc_inq_grpname(gids.get_int(i*4), name),
                     __FILE__, __LINE__)  
          objs << RNetCDFGroup.new(ncid, name.read_string)
        end
      end
      objs
    end
  end
  def RNCUtil.getAllVariables(ncid)
    withFFIVariables(num:[:int, 1], ids:[:int,128],
                     name:[:char,1024]) do
      | num, ids, name |
      next nil if ncerr(FFINetCDF.nc_inq_varids(ncid, num, ids),
                          __FILE__, __LINE__)
      objs = []
      for i in 0...num.read_int do
        vid = ids.get_int32(i*4)
        if not ncerr(FFINetCDF.nc_inq_varname(ncid, vid, name),
                     __FILE__, __LINE__)
          objs << RNetCDFVariable.new(ncid, name.read_string)
        end
      end
      objs
    end
  end
end

