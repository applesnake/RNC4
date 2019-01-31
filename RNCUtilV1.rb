# coding: utf-8
require 'FFINetCDF'
require 'ffi'

module RNCUtilV1
  def RNCUtilV1.withFFIVariables(**args, &block)
    ffi_vars = []
    for k,v in args do
      fv = FFI::MemoryPointer.new(v[0], v[1])
      ffi_vars << fv
    end
    ret = block.call(*ffi_vars)
    return ret
  end

  def RNCUtilV1.groupIds(ncid, path = nil)
    out = []
    withFFIVariables(num:[:int, 1], gids:[:int, 128]) do | num, gids |
      r = FFINetCDF.nc_inq_grps(ncid, num, gids)
      return [] if r != FFINetCDF::NC_NOERR
      for i in 0...num.read_int do
        out << gids.get_int(i*4)
      end
      return out
    end
  end
  
  def RNCUtilV1.groupIdForPath(ncid, path)
    if path == "/" then
      return ncid
    end
    pathes = path.split("/")
    pathes = pathes[1, pathes.length];
    sub_ids = [nil]*(pathes.length)
    tid = ncid
    if pathes.length > 0 then
      withFFIVariables(num:[:int, 1], gids:[:int, 128],
                       ss:[:char, 1024]) do | num, gids, ss |
        npath = 0
        pathes.each do | s |
          r = FFINetCDF.nc_inq_grps(tid, num, gids)
          return nil if ncerr(r, __FILE__, __LINE__)
          found = nil
          for i in 0...num.get_int(0*4) do
            gid = gids.get_int(i*4)
            r = FFINetCDF.nc_inq_grpname(gid, ss)
            return nil if ncerr(r, __FILE__, __LINE__)
            if s == ss.read_string then
              found = gid
            end
            if found then
              break
            end
          end
          
          if found then            
            sub_ids[npath] = found
            npath += 1
            tid = found
          else
            break
          end
        end        
      end
    end
    return sub_ids[-1]
  end

  def RNCUtilV1.variableIdForPath(ncid, path)
    if path[-1] == "/" then
      puts "Bad variable path.Variable path should terminated without '/'"
      return nil
    end
    
    a = path.split("/")
    a = a[1,a.length] if a[0] == ""
    if a.length == 1 then
      withFFIVariables(vid: [:int, 1]) do | vid |
        r = FFINetCDF.nc_inq_varid(ncid, a[0], vid)
        return nil if ncerr(r,__FILE__, __LINE__)
        return vid.read_int, ncid
      end
    else
      b = a[0,a.length-1]
      gid = groupIdForPath(ncid, "/" + b.join("/") + "/")
      return nil if not gid or gid < 0
      withFFIVariables(vid: [:int, 1]) do | vid |
        r = FFINetCDF.nc_inq_varid(gid, a[-1], vid)
        return nil if r != FFINetCDF::NC_NOERR
        return vid.read_int, gid
      end
    end
  end

  def RNCUtilV1.groupNameOf(ncid, gid)
    withFFIVariables(name:[:char, 1024]) do | name |
      r = FFINetCDF.nc_inq_grpname(gid, name)
      return nil if r != FFINetCDF::NC_NOERR
      return name.read_string
    end
  end
  
  def RNCUtilV1.groupNames(ncid, path)
    gid = ncid
    if path != "/" then
      gid = groupIdForPath(ncid, path)
    end
    return [] if not gid or gid < 0
    names = []
    withFFIVariables(num:[:int, 1],
                     gids:[:int, 128],
                     str:[:char, 1024]) do | num, gids, str |
      r = FFINetCDF.nc_inq_grps(gid, num, gids)
      return nil if r != FFINetCDF::NC_NOERR
      for i in 0...num.get_int(0) do
        gid2 = gids.get_int(i*4)
        r = FFINetCDF.nc_inq_grpname(gid2,str)
        return nil if r != FFINetCDF::NC_NOERR
        names << str.read_string
      end
    end
    return names
  end

  def RNCUtilV1.variableNames(ncid, path)
    if path[-1] != "/" then
      puts "Only group has variables."
      return nil
    end
    tid = ncid
    if path != "/" then
      tid = groupIdForPath(ncid, path)
    end
    names = []
    withFFIVariables(num:[:int, 1],
                     vids:[:int, 128],
                     str:[:char, 1024]) do | num, vids, str |
      r = FFINetCDF.nc_inq_varids(tid, num, vids)
      return nil if r != FFINetCDF::NC_NOERR
      for i in 0...num.get_int(0) do
        vid = vids.get_int(i*4)
        r = FFINetCDF.nc_inq_varname(tid, vid, str)
        return nil if ncerr(r, __FILE__, __LINE__)
        names << str.read_string
      end
    end
    return names;
  end

  def RNCUtilV1.variableIdByName(ncid, name)
    FFI::MemoryPointer.new(:int, 1) do | vid |
      r = FFINetCDF.nc_inq_varid(ncid, name, vid)
      return nil if r != FFINetCDF::NC_NOERR
      return vid.read_int
    end
  end

  
  def RNCUtilV1.variableDimensionNames(ncid, var)
    vid = (var.class == Integer) ? var : nil
    vname = (var.class == String) ? var : nil
    if vname and (not vid) then
      vid = variableIdByName(ncid, vname)
    end
    return nil if not vid 
    names =  []
    withFFIVariables(num:[:int, 1],
                     did:[:int, 128],
                     dname:[:char, 1024]) do | num, did, dname |
      r = FFINetCDF.nc_inq_varndims(ncid, vid, num)
      return nil if r != FFINetCDF::NC_NOERR
      r = FFINetCDF.nc_inq_vardimid(ncid, vid, did)
      return nil if r != FFINetCDF::NC_NOERR
      for i in 0...num.read_int do
        t = did.get_int(4*i)
        r = FFINetCDF.nc_inq_dimname(ncid, t, dname)
        return nil if r != FFINetCDF::NC_NOERR
        names << dname.read_string
      end
    end
    return names
  end

  def RNCUtilV1.variableDimensionIds(ncid, var)
    vid = (var.class == Integer) ? var : nil
    vname = (var.class == String) ? var : nil
    if vname and (not vid) then
      vid = variableIdByName(ncid, vname)
    end
    return nil if not vid 
    out =  []
    withFFIVariables(num:[:int, 1],
                     did:[:int, 128],
                     dname:[:char, 1024]) do | num, did, dname |
      r = FFINetCDF.nc_inq_varndims(ncid, vid, num)
      return nil if r != FFINetCDF::NC_NOERR
      r = FFINetCDF.nc_inq_vardimid(ncid, vid, did)
      return nil if r != FFINetCDF::NC_NOERR
      for i in 0...num.read_int do
        out << [did.get_int(4*i), ncid]
      end
    end
    out
  end

  def RNCUtilV1.dimIdsForPath(ncid, path = nil)
    out = []
    if not path then
      withFFIVariables(num:[:int, 1],
                       dids:[:int, 1024],
                       name:[:char, 1024]) do | num, dids, name |
        r = FFINetCDF.nc_inq_dimids(ncid, num, dids, 0)
        return nil if r != FFINetCDF::NC_NOERR
        for i in 0...num.read_int do
          out << dids.get_int(i*4)
        end
      end
      out
    end
    if path[-1] == "/" then
      gid = groupIdForPath(ncid, path)
      return dimensionIds(gid, nil)
    end
    vid,gid = variableIdForPath(ncid, path)
    return nil if not vid  or vid < 0
    return variableDimensionIds(gid, vid)
  end

  def RNCUtilV1.dimensionIds(ncid, path = nil)
    out = []
    if not path then
      withFFIVariables(num:[:int, 1],
                       dids:[:int, 1024],
                       name:[:char, 1024]) do | num, dids, name |
        r = FFINetCDF.nc_inq_dimids(ncid, num, dids, 0)
        return [] if ncerr(r, __FILE__, __LINE__)
        
        for i in 0...num.read_int do
          out << [dids.get_int(i*4), ncid]
        end
      end
      return out
    end
    
    if path[-1] == "/" then
      gid = groupIdForPath(ncid, path)
      return dimensionIds(gid, nil)
    end
    vid,gid = variableIdForPath(ncid, path)
    return nil if not vid  or vid < 0
    return variableDimensionIds(gid, vid)
  end
  def RNCUtilV1.variableIds(ncid, path = nil)
    out = []
    if not path then
      withFFIVariables(num:[:int, 1],
                       vids:[:int, 1024],
                       name:[:char, 1024]) do | num, vids, name |
        r = FFINetCDF.nc_inq_varids(ncid, num, vids)
        return nil if r != FFINetCDF::NC_NOERR
        for i in 0...num.read_int do
          out << vids.get_int(i*4)
        end
      end
      return out
    end
    if path[-1] == "/" then
      return []
    end
    vid,gid = variableIdForPath(ncid, path)
    return [vid]
  end
  def RNCUtilV1.variableNameOf(ncid, vid)
    withFFIVariables(name:[:char, 1024]) do | name|
      r = FFINetCDF.nc_inq_varname(ncid, vid, name)
      return nil if r != FFINetCDF::NC_NOERR
      return name.read_string
    end
  end
  
  def RNCUtilV1.dimensionNameOf(ncid, did)
    withFFIVariables(name:[:char, 1024]) do | name |
      r = FFINetCDF.nc_inq_dimname(ncid, did, name)
      return nil if r != FFINetCDF::NC_NOERR
      return name.read_string
    end
  end
  def RNCUtilV1.dimensionNames(ncid, path = nil)
    path = nil if path and path == "/"
    names = []
    if not path then
      withFFIVariables(num:[:int, 1],
                       dids:[:int, 1024],
                       name:[:char, 1024]) do | num, dids, name |
        r = FFINetCDF.nc_inq_dimids(ncid, num, dids, 0)
        return nil if r != FFINetCDF::NC_NOERR
        for i in 0...num.read_int do
          r = FFINetCDF.nc_inq_dimname(ncid, dids.get_int(i*4), name)
          if r != FFINetCDF::NC_NOERR then
            return nil
          end
          names << name.read_string
        end
      end
      return names
    end
    if path[-1] == "/" then
      gid = groupIdForPath(ncid, path)
      return dimensionNames(gid, nil)
    end
    vid,gid = variableIdForPath(ncid, path)
    return nil if not vid  or vid < 0
    return variableDimensionNames(gid, vid)
  end  
  def RNCUtilV1.dimensionIdAndNameForPath(ncid, path)
    path = nil if path == "/"
    out = {}
    RNCUtilV1.dimensionIds(ncid, path).each do | did, gid |
      out[RNCUtilV1.dimensionNameOf(gid, did)] = did
    end
    return out
  end
  
  def RNCUtilV1.dimensionLenAndNameForPath(ncid, path)
    path = nil if path == "/"
    out = []
    RNCUtilV1.dimensionIds(ncid, path).each do | did, gid |
      withFFIVariables(len:[:ulong, 1]) do | len |
        r = FFINetCDF.nc_inq_dimlen(gid, did, len)
        return nil if ncerr(r, "DimLenAndName")
        out << [RNCUtilV1.dimensionNameOf(gid, did), len.read_uint32]
      end
    end
    return out
  end
  
  def RNCUtilV1.groupAttributeNamesAndTypes(ncid)
    out = []
    withFFIVariables(num:[:int, 1],
                     name:[:char, 1024],
                     vtype:[:int, 1]) do 
      | num, name, vtype|
      r = FFINetCDF.nc_inq_natts(ncid, num)
      return [] if r != FFINetCDF::NC_NOERR
      for i in 0...num.read_int do
        r = FFINetCDF.nc_inq_attname(ncid, FFINetCDF::NC_GLOBAL, i, name)
        return [] if r != FFINetCDF::NC_NOERR
        r = FFINetCDF.nc_inq_atttype(ncid,
                                     FFINetCDF::NC_GLOBAL,
                                     name.read_string, vtype)
        
        return [] if ncerr(r)
        out << [name.read_string, vtype.read_int]
      end
      return out
    end
  end
  def RNCUtilV1.variableAttributeNamesAndTypes(ncid, vid)
    out = []
    withFFIVariables(num:[:int, 1],
                     name:[:char, 1024],
                     vtype:[:int, 1]) do 
      | num, name, vtype|
      r = FFINetCDF.nc_inq_varnatts(ncid, vid, num)
      return [] if ncerr(r,__FILE__, __LINE__)
      for i in 0...num.read_int do
        r = FFINetCDF.nc_inq_attname(ncid, vid, i, name)
        return [] if ncerr(r,__FILE__, __LINE__)
        r = FFINetCDF.nc_inq_atttype(ncid,vid,name.read_string, vtype)
        return [] if ncerr(r,__FILE__, __LINE__)
        out << [name.read_string, vtype.read_int]
      end
      return out
    end
  end
  
  def RNCUtilV1.variableAttributeLenAndNames(ncid, vid, &block)
    out = []
    withFFIVariables(num:[:int, 1], name:[:char, 1024], len:[:int,1]) do
      |num, name, len |
      r = FFINetCDF.nc_inq_varnatts(ncid, vid, num)
      return [] if r != FFINetCDF::NC_NOERR
      for i in 0...num.read_int do
        r = FFINetCDF.nc_inq_attname(ncid, vid, i, name)
        return [] if r != FFINetCDF::NC_NOERR
        r = FFINetCDF.nc_inq_attlen(ncid, vid, name.read_string, len)
        t = [len.read_int, name.read_string]
        block.call(*t) if block
        out << t
      end
      return out
    end
  end
  def RNCUtilV1.variableAttributeIdAndNames(ncid, vid, &block)
    return nil if not vid 
    out = []
    withFFIVariables(num:[:int, 1], name:[:char, 1024], aid:[:int,1]) do
      |num, name, aid |
      r = FFINetCDF.nc_inq_varnatts(ncid, vid, num)
      return [] if r != FFINetCDF::NC_NOERR
      for i in 0...num.read_int do
        r = FFINetCDF.nc_inq_attname(ncid, vid, i, name)
        return [] if r != FFINetCDF::NC_NOERR
        r = FFINetCDF.nc_inq_attid(ncid, vid, name.read_string, aid)
        t = [aid.read_int, name.read_string]
        block.call(*t) if block
        out << t
      end
      return out
    end
  end
  def RNCUtilV1.variableType(ncid, vid)
    withFFIVariables(vtype:[:int, 1]) do | vtype |
      r = FFINetCDF.nc_inq_vartype(ncid, vid, vtype)
      return nil if r != FFINetCDF::NC_NOERR
      return FFINetCDF::NC_TYPES[vtype.read_int]
    end
  end
  def RNCUtilV1.getVarBinary(ncid, vid, type, count)
    size = count * FFINetCDF::NC_TYPE_SIZE[type]
    withFFIVariables(bin:[:char, size]) do | bin |      
      r = FFINetCDF.nc_get_var(ncid, vid, bin)
      return nil if r != FFINetCDF::NC_NOERR
      return bin.get_bytes(0, size)
    end
  end
  def RNCUtilV1.createGroup(ncid, name)
    withFFIVariables(gid:[:int, 1]) do | gid |
      r = FFINetCDF.nc_def_group(ncid, name, gid)
      return nil if r != FFINetCDF::NC_NOERR
      return gid.read_int32
    end
  end
  def RNCUtilV1.createDimension(ncid, name, len)
    withFFIVariables(did:[:int, 1])do | did |
      FFINetCDF.nc_redef(ncid)
      r = FFINetCDF.nc_def_dim(ncid, name, len, did)
      FFINetCDF.nc_enddef(ncid)
      return nil if r != FFINetCDF::NC_NOERR
      return did.read_int32
    end
  end
  def RNCUtilV1.createVar(ncid, name, type, dims)
    if type.class != Integer then
      vtype = FFINetCDF::NC_TYPE_IDS[type]
    else
      vtype = type
    end
    withFFIVariables(dimids:[:int,128], vid:[:int, 1]) do
      |dimids, vid |
      for i in 0...dims.length do
        FFINetCDF::nc_inq_dimid(ncid, dims[i].to_s, dimids[i])
      end
      if name[0] == "/" then
        name = name[1,name.length]
      end
      r = FFINetCDF.nc_def_var(ncid, name, vtype,
                               dims.length, dimids, vid)
      if ncerr(r,"createVar") then
        return nil
      end
      return vid.read_int
    end
  end
  def RNCUtilV1.putBinary(ncid, vid, type, bin)
    withFFIVariables(cbin:[:char, bin.length]) do | cbin |
      cbin.put_bytes(0, bin)
      r = FFINetCDF.nc_put_var(ncid, vid, cbin)
      # 没有nc_enddef调用之前nc_put_var会失败。
      # 这里如何设计将在后续开发中考虑。
      if r != FFINetCDF::NC_NOERR then # 错误处理信息需要增加。
        puts FFINetCDF.nc_strerror(r)
        return nil 
      end
      return true
    end
  end
  def RNCUtilV1.readGroupAttributeValue(ncid, name, vtype)
    withFFIVariables(value:[:char, 4096],len:[:ulong, 1]) do | value,len |
      return nil if(ncerr(FFINetCDF.nc_get_att(ncid, FFINetCDF::NC_GLOBAL, name, value)))
      return nil if(ncerr(FFINetCDF.nc_inq_attlen(ncid, FFINetCDF::NC_GLOBAL, name, len)))
      
      vtype = FFINetCDF::NC_TYPES[vtype]
      puta ncid, vtype, name
      cnt = len.read_uint32
      vid = FFINetCDF::NC_GLOBAL
      withFFIVariables(value:[:char, 4096],len:[:ulong, 1]) do | value,len |
        return nil if(ncerr(FFINetCDF.nc_get_att(ncid, vid, name, value)))
        return nil if(ncerr(FFINetCDF.nc_inq_attlen(ncid, vid, name, len)))
        cnt = len.read_uint32
        case vtype
        when :NC_STRING
          return value.read_string
        when :NC_BYTE
          return value.get_array_of_int8(0, cnt) if cnt > 1
          return value.read_int8
        when :NC_CHAR          
          return value.read_string
        when :NC_SHORT
          return value.get_array_of_int16(0,cnt) if cnt > 1
          return value.read_int16
        when :NC_LONG
          return value.get_array_of_int32(0,cnt) if cnt > 1
          return value.read_int32
        when :NC_INT
          return value.get_array_of_int32(0,cnt) if cnt > 1
          return value.read_int32
        when :NC_FLOAT
          return value.get_array_of_float32(0,cnt)  if cnt > 1
          return value.read_float
        when :NC_DOUBLE
          return value.get_array_of_float64(0,cnt) if cnt > 1
          return value.read_double
        when :NC_UBYTE
          return value.get_array_of_uint8(0,cnt) if cnt > 1
          return value.read_uint8
        when :NC_USHORT
          return value.get_array_of_uint16(0,cnt) if cnt > 1
          return value.read_uint16
        when :NC_UINT
          return value.get_array_of_uint32(0,cnt) if cnt > 1
          return value.read_uint32
        when :NC_INT64
          return value.get_array_of_int64(0,cnt) if cnt > 1
          return value.read_int64
        when :NC_UINT64
          return value.get_array_of_uint64(0,cnt) if cnt > 1
          return value.read_uint64
        else
        end
      end
    end
  end
  def RNCUtilV1.readVariableAttributeValue(ncid, vid, name, vtype)
    withFFIVariables(value:[:char, 4096],len:[:ulong, 1]) do | value,len |
      return nil if(ncerr(FFINetCDF.nc_get_att(ncid, vid, name, value)))
      return nil if(ncerr(FFINetCDF.nc_inq_attlen(ncid, vid, name, len)))
      vtype = FFINetCDF::NC_TYPES[vtype]
      cnt = len.read_uint32
      case vtype
      when :NC_STRING
        return value.read_string
      when :NC_BYTE
        return value.get_array_of_int8(0, cnt) if cnt > 1
        return value.read_int8
      when :NC_CHAR
        return value.read_string
      when :NC_SHORT
        return value.get_array_of_int16(0,cnt) if cnt > 1
        return value.read_int16
      when :NC_LONG
        return value.get_array_of_int32(0,cnt) if cnt > 1
        return value.read_int32
      when :NC_INT
        return value.get_array_of_int32(0,cnt) if cnt > 1
        return value.read_int32
      when :NC_FLOAT
        return value.get_array_of_float32(0,cnt)  if cnt > 1
        return value.read_float
      when :NC_DOUBLE
        return value.get_array_of_float64(0,cnt) if cnt > 1
        return value.read_double
      when :NC_UBYTE
        return value.get_array_of_uint8(0,cnt) if cnt > 1
        return value.read_uint8
      when :NC_USHORT
        return value.get_array_of_uint16(0,cnt) if cnt > 1
        return value.read_uint16
      when :NC_UINT
        return value.get_array_of_uint32(0,cnt) if cnt > 1
        return value.read_uint32
      when :NC_INT64
        return value.get_array_of_int64(0,cnt) if cnt > 1
        return value.read_int64
      when :NC_UINT64
        return value.get_array_of_uint64(0,cnt) if cnt > 1
        return value.read_uint64
      else
      end
    end
  end
  def RNCUtilV1.dumpNCSchema(ncid)
    ffi = FFINetCDF
    schema = {}
    gpnames = groupNames(ncid, "/")
    gpnames.each do | name |
      name1 = groupNames(ncid, "/#{name}")
      if name1 and name1.length > 0 then
        gpnames << name1
      end
    end
    schema = {}
    gpnames.flatten!
    gpnames.uniq!
    gpnames = gpnames.map do | i |
      t = i
      if i != "/" then
        t = i
      end
      t
    end
    gpnames << ""
    gpnames.each do | path |
      px = (path == "" ? "/" : "/#{path}/")
      gid = groupIdForPath(ncid, px)
      if gid and gid > 0 then
        schema[path] = {} if not schema[path]
        a = groupAttributeNamesAndTypes(gid)
        t = {}
        if a and a.length > 0 then
          a.each do | pair |
            aname,vtype = pair[0], pair[1]
            value = readGroupAttributeValue(gid, aname, vtype)
            t[aname] = value
          end
        end
        schema[path][:attributes] = t
        d = dimensionLenAndNameForPath(ncid, px)
        t = {}
        if d and d.length > 0 then
          d.each do | k, v |
            t[k] = v
          end
        end
        schema[path][:dimensions] = t
        t = {}
        variableNames(ncid, px).each do | vname |
          t[vname] = {} if not t[vname]
          vid,pid = variableIdForPath(ncid, "#{px}#{vname}")
          puta vid,pid, px, vname
          b = variableAttributeNamesAndTypes(pid, vid[0])
          h = {}
          if b and b.length > 0 then
            b.each do | pair |
              aname, vtype = *pair
              value = readVariableAttributeValue(gid, vid, aname, vtype)
              h[vname] = value
            end
          end
          t[vname][:attributes] = h
          t[vname][:dimensions] = []
          
          t[vname][:dimensions] = dimensionLenAndNameForPath(ncid, "#{px}#{vname}")
          
          withFFIVariables(vtype:[:int, 1]) do | vtype |
            FFINetCDF.nc_inq_vartype(gid, vid, vtype)
            t[vname][:type] = vtype.read_int
          end
        end
        schema[path][:variables] = t
      end
    end
    #puts schema[:dimensions].to_s
    return schema
  end
  def RNCUtilV1.rubyTypeToNCType(v) 
    v = v
    if v.class == Array then
      v = v[0]
      klass = v.class
    else
      klass = v.class
    end
    if klass == String then
      return :NC_CHAR
    elsif klass == Integer then
      return :NC_INT
    elsif klass ==  Float then
      return :NC_DOUBLE
    else
      return nil
    end
  end
  def RNCUtilV1.putVariableAttribute(ncid, vid, name, value)
    vtype = rubyTypeToNCType(value)
    if not vtype then
      STDERR.puts "Ruby type: #{value.class} is not supported for NC attribute."
      return nil
    end
    withFFIVariables(cval:[:char, 4096]) do | cval |
      len = 1
      if value.class == Array then
        len = value.length
      elsif value.class == String then
        len = value.length
      end
      if value.class != Array then
        value = [value]
      end
      nctype = FFINetCDF::NC_TYPE_IDS[vtype]
      case vtype
      when :NC_INT
        cval.put_array_of_int32(0, value)
        FFINetCDF.nc_redef(ncid)
        nctype = 4
        r = FFINetCDF.nc_put_att(ncid, vid, name, nctype, len, cval)
        FFINetCDF.nc_enddef(ncid)
      when :NC_DOUBLE
        cval.put_array_of_float64(0, value)
        FFINetCDF.nc_redef(ncid)
        r = FFINetCDF.nc_put_att(ncid, vid, name, nctype, len, cval)
        FFINetCDF.nc_enddef(ncid)
      when :NC_CHAR
        len = value[0].length
        FFINetCDF.nc_redef(ncid)
        r = FFINetCDF.nc_put_att(ncid, vid, name, 2, len, value[0])
        FFINetCDF.nc_enddef(ncid)
      end
      return r
      #return FFINetCDF.nc_put_att(ncid, vid, name, t, len, cval)
    end
  end
  def RNCUtilV1.newGroup(ncid, name)
    withFFIVariables(gid:[:int, 1], parent_name:[:char, 1024]) do | gid , parent_name|
      FFINetCDF.nc_redef(ncid)
      r = FFINetCDF.nc_def_grp(ncid, name, gid)
      FFINetCDF.nc_enddef(ncid)
      return nil,nil if ncerr(r)
      r = FFINetCDF.nc_inq_grpname(ncid, parent_name)
      return nil,nil if ncerr(r)
      return gid.read_int, parent_name.read_string  + "/" + name
    end
  end
end
