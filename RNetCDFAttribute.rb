require 'FFINetCDF'
require 'RNCUtil'
require 'RNCDelegate'
class Array
  def allValueSameClass?
    tc = self[0].class
    self.each do | v |
      if v.class != tc then
        return false
      end
    end
    return true
  end
end

class RNetCDFAttribute
  def initialize(ncid, oid, name)
    @ncid = ncid # maybe root ncid or group-id
    @oid  = oid # maybe group-id or variable-id
    @name = name
    return self
  end
  def def(v)
    vid = @oid ? @oid : FFINetCDF::NC_GLOBAL
    r,e = RNCUtil.cond(v.class,
                       String: proc {
                         xtype = FFINetCDF::NC_CHAR
                         RNCUtil.withFFIVariables(val:[:char, v.length + 1]) do
                           | val |
                           val.put_string(0, v)
                           next nil, nil if ncerr(FFINetCDF.nc_put_att(@ncid, vid, @name,
                                                                       xtype, v.length, val),
                                                  __FILE__, __LINE__)
                           next true, nil
                         end
                       },
                       Integer: proc {
                         xtype = FFINetCDF::NC_INT
                         RNCUtil.withFFIVariables(val:[:int, 1]) do | val |
                           val.put_int32(0, v)
                           next nil, nil if ncerr(FFINetCDF.nc_put_att(@ncid, vid, @name,
                                                                       xtype, 1, val),
                                                  __FILE__, __LINE__)
                           next true,nil
                         end
                       },
                       Float: proc {
                         xtype = FFINetCDF::NC_DOUBLE
                         RNCUtil.withFFIVariables(vtype:[:int, 1], val:[:float, 1]) do | vtype, val |
                           if(@name == "_FillValue") then
                             FFINetCDF.nc_inq_vartype(@ncid, @oid, vtype)
                             xtype = vtype.read_int
                             if xtype == FFINetCDF::NC_FLOAT then
                               val.put_float32(0, v)
                             else
                               val = FFI::MemoryPointer.new :double, 1
                               val.put_float64(0, v);
                             end
                           else
                             val.put_float64(0, v)
                           end
                           next nil,nil if ncerr(FFINetCDF.nc_put_att(@ncid, vid, @name,
                                                                      xtype, 1, val),
                                                 __FILE__, __LINE__)
                           next true,nil
                         end
                       },
                       Array: proc {
                         __putArray(@ncid, vid, @name, v)
                       },
                       :t => proc {
                         next nil, "Unkown Class #{v.class}"
                       }
                      )
    if not r and e then
      STDERR.puts "ERROR: #{e}"
      return nil
    end
    return self
  end
  def RNetCDFAttribute=(v)
    self.def(v)
  end
  def __putArray(ncid, vid, name, ary)
    if not ary.allValueSameClass? then
      STDERR.puts "Attribute array members must be same type."
      return nil,nil
    end
    klass = ary[0].class
    if klass == Array then
      STDERR.puts "Embeded array is not supported by RNetCDFAttribute."
      return nil, nil
    end
    if klass == String then
      STDERR.ptus "String array is not supported by NetCDF Attribute.Only Integer(INT64 or Float(FLOAT64,DOUBLE)"
      return nil, nil
    end
    RNCUtil.cond(klass,
                 Integer: proc {
                   RNCUtil.withFFIVariables(val:[:int, ary.length]) do | val |
                     val.put_array_of_int(0, ary)
                     next nil, nil if ncerr(FFINetCDF.nc_put_att(@ncid, vid, name, 
                                                                 FFINetCDF::NC_INT,
                                                                 ary.length, val), __FILE__, __LINE__)
                     next true, nil
                   end
                 },
                 Float: proc {
                   RNCUtil.withFFIVariables(vtype:[:int, 1], val:[:float, ary.length]) do | vtype, val |
                     xtype = FFINetCDF::NC_FLOAT
                     if name == "_FillValue" then
                       next nil,nil if ncerr(FFINetCDF.nc_inq_vartype(ncid, vid, vtype))
                       if vtype.read_int == FFINetCDF::NC_DOUBLE then
                         xtype = FFINetCDF::NC_DOUBLE
                         val = FFI::MemoryPointer.new :double, 1
                         val.put_64(0, v)
                       end
                     else
                       val.put_array_of_float32(0, ary)                     
                     end
                     next nil,nil if ncerr(FFINetCDF.nc_put_att(@ncid, vid, name,
                                                                xtype,
                                                                ary.length, val), __FILE__, __LINE__)
                     next true, nil
                   end
                 },
                 t: proc {
                   next nil, "Unkown Class #{klass}"
                 }
                )
  end
  def value
    oid = @oid ? @oid : FFINetCDF::NC_GLOBAL
    RNCUtil.withFFIVariables(xtype:[:int, 1],len:[:ulong, 1])  do
      | xtype, len |
      return nil if ncerr(FFINetCDF.nc_inq_atttype(@ncid, oid, @name, xtype),
                          __FILE__, __LINE__)
      return nil if ncerr(FFINetCDF.nc_inq_attlen(@ncid, oid, @name, len),
                          __FILE__, __LINE__)
      cnt = len.read_uint32
      byte_num = cnt
      rd = nil
      case xtype.read_int
      when FFINetCDF::NC_BYTE
        byte_num *= 1
        rd = proc do
          RNCUtil.withFFIVariables(values:[:char, byte_num]) do | values |
            next if ncerr(FFINetCDF.nc_get_att(@ncid, oid, @name, values),
                          __FILE__, __LINE__)
            next values.get_array_of_int8(0, cnt)
          end
        end
      when FFINetCDF::NC_CHAR
        byte_num *= 1
        rd = proc do
          RNCUtil.withFFIVariables(values:[:char, byte_num]) do | values |
            next if ncerr(FFINetCDF.nc_get_att(@ncid, oid, @name, values),
                          __FILE__, __LINE__)
            next values.read_string
          end
        end
      when FFINetCDF::NC_SHORT
        byte_num *= 2
        rd = proc do
          RNCUtil.withFFIVariables(values:[:char, byte_num]) do | values |
            next if ncerr(FFINetCDF.nc_get_att(@ncid, oid, @name, values),
                          __FILE__, __LINE__)
            next values.get_array_of_int16(0, cnt)
          end
        end
      when FFINetCDF::NC_INT
        byte_num *= 4
        rd = proc do
          RNCUtil.withFFIVariables(values:[:char, byte_num]) do | values |
            next if ncerr(FFINetCDF.nc_get_att(@ncid, oid, @name, values),
                          __FILE__, __LINE__)
            next values.get_array_of_int32(0, cnt)
          end
        end
      when FFINetCDF::NC_FLOAT
        byte_num *= 4
        rd = proc do
          RNCUtil.withFFIVariables(values:[:char, byte_num]) do | values |
            next if ncerr(FFINetCDF.nc_get_att(@ncid, oid, @name, values),
                          __FILE__, __LINE__)
            next values.get_array_of_float32(0, cnt)
          end
        end
      when FFINetCDF::NC_DOUBLE
        byte_num *= 8
        rd = proc do
          RNCUtil.withFFIVariables(values:[:char, byte_num]) do | values |
            next if ncerr(FFINetCDF.nc_get_att(@ncid, oid, @name, values),
                          __FILE__, __LINE__)
            next values.get_array_of_float64(0, cnt)
          end
        end
      when FFINetCDF::NC_UBYTE
        byte_num *= 1
        rd = proc do
          RNCUtil.withFFIVariables(values:[:char, byte_num]) do | values |
            next if ncerr(FFINetCDF.nc_get_att(@ncid, oid, @name, values),
                          __FILE__, __LINE__)
            next values.get_array_of_uint8(0, cnt)
          end
        end
      when FFINetCDF::NC_USHORT
        byte_num *= 2
        rd = proc do
          RNCUtil.withFFIVariables(values:[:char, byte_num]) do | values |
            next if ncerr(FFINetCDF.nc_get_att(@ncid, oid, @name, values),
                          __FILE__, __LINE__)
            next values.get_array_of_uint16(0, cnt)
          end
        end
      when FFINetCDF::NC_UINT
        byte_num *= 4
        rd = proc do
          RNCUtil.withFFIVariables(values:[:char, byte_num]) do | values |
            next if ncerr(FFINetCDF.nc_get_att(@ncid, oid, @name, values),
                          __FILE__, __LINE__)
            next values.get_array_of_uint32(0, cnt)
          end
        end
      when FFINetCDF::NC_INT64
        byte_num *= 8
        rd = proc do
          RNCUtil.withFFIVariables(values:[:char, byte_num]) do | values |
            next if ncerr(FFINetCDF.nc_get_att(@ncid, oid, @name, values),
                          __FILE__, __LINE__)
            next values.get_array_of_int64(0, cnt)
          end
        end
      when FFINetCDF::NC_UINT6
        byte_num *= 8
        rd = proc do
          RNCUtil.withFFIVariables(values:[:char, byte_num]) do | values |
            next if ncerr(FFINetCDF.nc_get_att(@ncid, oid, @name, values),
                          __FILE__, __LINE__)
            next values.get_array_of_uint64(0, cnt)
          end
        end
      else
      end
      rd.call
    end
  end
end


