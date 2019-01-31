require 'ffi'

module FFINetCDF
  extend FFI::Library
  ffi_lib "netcdf"
  ffi_convention :stdcall
  attach_function :nc_abort, [:int], :int
  attach_function :nc_close, [:int], :int
  attach_function :nc_create, [:string, :int, :pointer], :int
  attach_function :nc_def_compound, [:int, :ulong, :string, :pointer], :int
  attach_function :nc_def_dim, [:int, :string, :ulong, :pointer], :int
  attach_function :nc_def_enum,[:int, :int, :string, :pointer], :int
  attach_function :nc_def_grp, [:int, :string, :pointer], :int
  attach_function :nc_def_opaque,[:int, :ulong, :string, :pointer], :int
  attach_function :nc_def_var,[:int, :string, :int, :int, :pointer, :pointer], :int
  attach_function :nc_def_var_deflate,[:int, :int, :int, :int, :int],:int
  attach_function :nc_def_var_chunking,[:int, :int, :int, :pointer], :int
  attach_function :nc_def_vlen,[:int, :string, :int, :pointer], :int
  attach_function :nc_del_att,[:int, :int, :string], :int
  attach_function :nc_enddef, [:int], :int
  attach_function :nc_free_string, [:ulong, :pointer], :int
  attach_function :nc_free_vlen, [:pointer], :int
  attach_function :nc_free_vlens, [:ulong, :ulong], :int
  attach_function :nc_get_att, [:int, :int, :string, :pointer], :int
  attach_function :nc_get_att_double, [:int, :int, :string, :pointer],:int
  attach_function :nc_get_att_float, [:int, :int, :string, :pointer],:int
  attach_function :nc_get_att_int, [:int, :int, :string, :pointer],:int
  attach_function :nc_get_att_long, [:int, :int, :string, :pointer],:int
  attach_function :nc_get_att_longlong, [:int, :int, :string, :pointer],:int
  attach_function :nc_get_att_schar, [:int, :int, :string, :pointer],:int
  attach_function :nc_get_att_short, [:int, :int, :string, :pointer],:int
  attach_function :nc_get_att_string, [:int, :int, :string, :pointer],:int
  attach_function :nc_get_att_text, [:int, :int, :string, :pointer],:int
  attach_function :nc_get_att_ubyte, [:int, :int, :string, :pointer],:int
  attach_function :nc_get_att_uchar, [:int, :int, :string, :pointer],:int
  attach_function :nc_get_att_uint, [:int, :int, :string, :pointer],:int
  attach_function :nc_get_att_ulonglong, [:int, :int, :string, :pointer],:int
  attach_function :nc_get_att_ushort, [:int, :int, :string, :pointer],:int
  attach_function :nc_get_var, [:int, :int, :pointer], :int
  attach_function :nc_get_var1,[:int, :int, :pointer, :pointer], :int
  attach_function :nc_get_var1_double, [:int, :int, :pointer, :pointer], :int
  attach_function :nc_get_var1_float, [:int, :int, :pointer, :pointer], :int
  attach_function :nc_get_var1_int, [:int, :int, :pointer, :pointer], :int
  attach_function :nc_get_var1_long, [:int, :int, :pointer, :pointer], :int
  attach_function :nc_get_var1_longlong, [:int, :int, :pointer, :pointer], :int
  attach_function :nc_get_var1_schar, [:int, :int, :pointer, :pointer], :int
  attach_function :nc_get_var1_short, [:int, :int, :pointer, :pointer], :int
  attach_function :nc_get_var1_string, [:int, :int, :pointer, :pointer], :int
  attach_function :nc_get_var1_text, [:int, :int, :pointer, :pointer], :int
  attach_function :nc_get_var1_ubyte, [:int, :int, :pointer, :pointer], :int
  attach_function :nc_get_var1_uchar, [:int, :int, :pointer, :pointer], :int
  attach_function :nc_get_var1_uint, [:int, :int, :pointer, :pointer], :int
  attach_function :nc_get_var1_ulonglong, [:int, :int, :pointer, :pointer], :int
  attach_function :nc_get_var1_ushort, [:int, :int, :pointer, :pointer], :int
  attach_function :nc_get_var_chunk_cache, [:int,:int,:pointer, :pointer, :pointer], :int
  attach_function :nc_get_var_double, [:int,:int,:pointer], :int
  attach_function :nc_get_var_float, [:int,:int,:pointer], :int
  attach_function :nc_get_var_int, [:int,:int,:pointer], :int
  attach_function :nc_get_var_long, [:int,:int,:pointer], :int
  attach_function :nc_get_var_longlong, [:int,:int,:pointer], :int
  attach_function :nc_get_var_schar, [:int,:int,:pointer], :int
  attach_function :nc_get_var_short, [:int,:int,:pointer], :int
  attach_function :nc_get_var_string, [:int,:int,:pointer], :int
  attach_function :nc_get_var_text, [:int,:int,:pointer], :int
  attach_function :nc_get_var_ubyte, [:int,:int,:pointer], :int
  attach_function :nc_get_var_uchar, [:int,:int,:pointer], :int
  attach_function :nc_get_var_uint, [:int,:int,:pointer], :int
  attach_function :nc_get_var_ulonglong, [:int,:int,:pointer], :int
  attach_function :nc_get_var_ushort, [:int,:int,:pointer], :int
  attach_function :nc_get_vara,[:int,:int, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_vara_double,[:int,:int, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_vara_float,[:int,:int, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_vara_int,[:int,:int, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_vara_long,[:int,:int, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_vara_longlong,[:int,:int, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_vara_schar,[:int,:int, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_vara_short,[:int,:int, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_vara_string,[:int,:int, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_vara_text,[:int,:int, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_vara_ubyte,[:int,:int, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_vara_uchar,[:int,:int, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_vara_uint,[:int,:int, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_vara_ulonglong,[:int,:int, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_vara_ushort,[:int,:int, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_varm,[:int,:int,:pointer, :pointer, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_varm_double,[:int,:int,:pointer, :pointer, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_varm_float,[:int,:int,:pointer, :pointer, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_varm_int,[:int,:int,:pointer, :pointer, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_varm_long,[:int,:int,:pointer, :pointer, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_varm_longlong,[:int,:int,:pointer, :pointer, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_varm_schar,[:int,:int,:pointer, :pointer, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_varm_short,[:int,:int,:pointer, :pointer, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_varm_string,[:int,:int,:pointer, :pointer, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_varm_text,[:int,:int,:pointer, :pointer, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_varm_ubyte,[:int,:int,:pointer, :pointer, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_varm_uchar,[:int,:int,:pointer, :pointer, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_varm_uint,[:int,:int,:pointer, :pointer, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_varm_ulonglong,[:int,:int,:pointer, :pointer, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_varm_ushort,[:int,:int,:pointer, :pointer, :pointer, :pointer, :pointer],:int
  attach_function :nc_get_vars,[:int,:int,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_get_vars_double,[:int,:int,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_get_vars_float,[:int,:int,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_get_vars_int,[:int,:int,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_get_vars_long,[:int,:int,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_get_vars_longlong,[:int,:int,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_get_vars_schar,[:int,:int,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_get_vars_short,[:int,:int,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_get_vars_string,[:int,:int,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_get_vars_text,[:int,:int,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_get_vars_ubyte,[:int,:int,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_get_vars_uchar,[:int,:int,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_get_vars_uint,[:int,:int,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_get_vars_ulonglong,[:int,:int,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_get_vars_ushort,[:int,:int,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_inq,[:int, :pointer, :pointer, :pointer, :pointer],:int
  attach_function :nc_inq_att,[:int,:int,:pointer,:pointer,:pointer],:int
  attach_function :nc_inq_attid,[:int,:int,:string,:pointer],:int
  attach_function :nc_inq_attlen,[:int,:int,:string,:pointer],:int
  attach_function :nc_inq_attname,[:int,:int,:int, :pointer], :int
  attach_function :nc_inq_atttype,[:int,:int,:string,:pointer],:int
  attach_function :nc_inq_compound,[:int,:int,:string, :pointer,:pointer],:int
  attach_function :nc_inq_compound_field,[:int, :int, :int, :string, :pointer, :pointer,:pointer,:pointer],:int
  attach_function :nc_inq_compound_fielddim_sizes,[:int, :int,:int, :pointer],:int
  attach_function :nc_inq_compound_fieldindex,[:int, :int, :string, :pointer], :int
  attach_function :nc_inq_compound_fieldname,[:int, :int, :int, :string], :int
  attach_function :nc_inq_compound_fieldndims,[:int, :int, :int, :pointer], :int
  attach_function :nc_inq_compound_fieldoffset,[:int, :int, :int, :pointer], :int
  attach_function :nc_inq_compound_fieldtype,[:int, :int, :int, :pointer], :int
  attach_function :nc_inq_compound_name, [:int, :int, :int, :string], :int
  attach_function :nc_inq_compound_nfields,[:int, :int, :pointer], :int 
  attach_function :nc_inq_compound_size,[:int, :int, :pointer], :int
  attach_function :nc_inq_dim,[:int, :int, :string, :pointer], :int
  attach_function :nc_inq_dimid, [:int, :string, :pointer], :int
  attach_function :nc_inq_dimids,[:int, :pointer, :pointer, :int], :int
  attach_function :nc_inq_dimlen,[:int, :int, :pointer], :int
  attach_function :nc_inq_dimname,[:int, :int, :pointer], :int
  attach_function :nc_inq_enum, [:int, :int, :string, :pointer ,:pointer,:pointer],:int
  attach_function :nc_inq_enum_ident, [:int, :int, :long_long, :string], :int
  attach_function :nc_inq_enum_member, [:int, :int, :int, :string, :pointer], :int
  attach_function :nc_inq_format, [:int,:pointer], :int
  attach_function :nc_inq_format_extended, [:int,:pointer,:pointer], :int
  attach_function :nc_inq_grp_full_ncid, [:int, :string,:pointer], :int
  attach_function :nc_inq_grp_ncid, [:int, :string, :pointer], :int
  attach_function :nc_inq_grp_parent, [:int, :pointer], :int
  attach_function :nc_inq_grpname, [:int, :pointer], :int
  attach_function :nc_inq_grpname_full, [:int, :pointer, :pointer], :int
  attach_function :nc_inq_grpname_len, [:int, :pointer], :int
  attach_function :nc_inq_grps, [:int, :pointer, :pointer], :int
  attach_function :nc_inq_natts, [:int, :pointer], :int
  attach_function :nc_inq_ncid, [:int, :string, :pointer], :int
  attach_function :nc_inq_ndims, [:int, :pointer], :int
  attach_function :nc_inq_opaque,[:int, :int, :string, :pointer], :int
  attach_function :nc_inq_path,[:int, :pointer, :pointer], :int
  attach_function :nc_inq_type,[:int, :int, :string, :pointer], :int
  attach_function :nc_inq_typeid,[:int, :string, :pointer], :int
  attach_function :nc_inq_typeids,[:int,:pointer,:pointer], :int
  attach_function :nc_inq_unlimdim,[:int,:pointer], :int
  attach_function :nc_inq_unlimdims,[:int, :pointer, :pointer], :int
  attach_function :nc_inq_user_type,[:int, :int, :string, :pointer, :pointer, :pointer, :pointer], :int
  attach_function :nc_inq_var,[:int, :int, :string, :pointer,:pointer,:pointer,:pointer], :int
  attach_function :nc_inq_var_chunking,[:int, :int, :pointer, :pointer], :int
  attach_function :nc_inq_var_deflate,[:int, :int, :pointer, :pointer, :pointer],:int
  attach_function :nc_inq_var_endian,[:int, :int, :pointer],:int
  attach_function :nc_inq_var_fill,[:int, :int, :pointer, :pointer], :int
  attach_function :nc_inq_var_fletcher32,[:int, :int, :pointer], :int
  attach_function :nc_inq_var_szip,[:int, :int, :pointer, :pointer], :int
  attach_function :nc_inq_vardimid,[:int, :int, :pointer], :int
  attach_function :nc_inq_varid,[:int, :string, :pointer], :int
  attach_function :nc_inq_varids,[:int, :pointer,:pointer],:int
  attach_function :nc_inq_varname,[:int, :int, :pointer],:int
  attach_function :nc_inq_varnatts,[:int, :int, :pointer], :int
  attach_function :nc_inq_varndims,[:int, :int, :pointer], :int
  attach_function :nc_inq_vartype,[:int, :int,:pointer], :int
  attach_function :nc_inq_vlen,[:int, :int, :string, :pointer,:pointer],:int
  attach_function :nc_insert_array_compound,[:int, :int, :string, :ulong, :int, :int, :pointer], :int
  attach_function :nc_insert_compound,[:int, :int, :string, :ulong, :int], :int
  attach_function :nc_insert_enum,[:int, :int, :string, :pointer], :int
  attach_function :nc_open,[:string, :int, :pointer], :int
  #attach_function :nc_open_mem,[:string, :int, :ulong, :pointer, :pointer], :int
  attach_function :nc_put_att,[:int, :int, :string, :int, :ulong, :pointer],:int
  attach_function :nc_put_att_double,[:int, :int, :string, :int, :ulong, :pointer],:int
  attach_function :nc_put_att_float,[:int, :int, :string, :int, :ulong, :pointer],:int
  attach_function :nc_put_att_int,[:int, :int, :string, :int, :ulong, :pointer],:int
  attach_function :nc_put_att_long,[:int, :int, :string, :int, :ulong, :pointer],:int
  attach_function :nc_put_att_longlong,[:int, :int, :string, :int, :ulong, :pointer],:int
  attach_function :nc_put_att_schar,[:int, :int, :string, :int, :ulong, :pointer],:int
  attach_function :nc_put_att_short,[:int, :int, :string, :int, :ulong, :pointer],:int
  attach_function :nc_put_att_string,[:int, :int, :string, :ulong, :pointer],:int
  attach_function :nc_put_att_text,[:int, :int, :string, :ulong, :pointer],:int
  attach_function :nc_put_att_ubyte,[:int, :int, :string, :int, :ulong, :pointer],:int
  attach_function :nc_put_att_uchar,[:int, :int, :string, :int, :ulong, :pointer],:int
  attach_function :nc_put_att_uint,[:int, :int, :string, :int, :ulong, :pointer],:int
  attach_function :nc_put_att_ulonglong,[:int, :int, :string, :int, :ulong, :pointer],:int
  attach_function :nc_put_att_ushort,[:int, :int, :string, :int, :ulong, :pointer],:int
  attach_function :nc_put_var,[:int, :int,:pointer],:int
  attach_function :nc_put_var1,[:int, :int, :pointer, :pointer],:int
  attach_function :nc_put_var1_double,[:int, :int, :pointer, :pointer],:int
  attach_function :nc_put_var1_float,[:int, :int, :pointer, :pointer],:int
  attach_function :nc_put_var1_int,[:int, :int, :pointer, :pointer],:int
  attach_function :nc_put_var1_long,[:int, :int, :pointer, :pointer],:int
  attach_function :nc_put_var1_longlong,[:int, :int, :pointer, :pointer],:int
  attach_function :nc_put_var1_schar,[:int, :int, :pointer, :pointer],:int
  attach_function :nc_put_var1_short,[:int, :int, :pointer, :pointer],:int
  attach_function :nc_put_var1_string,[:int, :int, :pointer, :pointer],:int
  attach_function :nc_put_var1_text,[:int, :int, :pointer, :pointer],:int
  attach_function :nc_put_var1_ubyte,[:int, :int, :pointer, :pointer],:int
  attach_function :nc_put_var1_uchar,[:int, :int, :pointer, :pointer],:int
  attach_function :nc_put_var1_uint,[:int, :int, :pointer, :pointer],:int
  attach_function :nc_put_var1_ulonglong,[:int, :int, :pointer, :pointer],:int
  attach_function :nc_put_var1_ushort,[:int, :int, :pointer, :pointer],:int
  attach_function :nc_put_var_double,[:int, :int, :pointer], :int
  attach_function :nc_put_var_float,[:int, :int, :pointer], :int
  attach_function :nc_put_var_int,[:int, :int, :pointer], :int
  attach_function :nc_put_var_long,[:int, :int, :pointer], :int
  attach_function :nc_put_var_longlong,[:int, :int, :pointer], :int
  attach_function :nc_put_var_schar,[:int, :int, :pointer], :int
  attach_function :nc_put_var_short,[:int, :int, :pointer], :int
  attach_function :nc_put_var_string,[:int, :int, :pointer], :int
  attach_function :nc_put_var_text,[:int, :int, :pointer], :int
  attach_function :nc_put_var_ubyte,[:int, :int, :pointer], :int
  attach_function :nc_put_var_uchar,[:int, :int, :pointer], :int
  attach_function :nc_put_var_uint,[:int, :int, :pointer], :int
  attach_function :nc_put_var_ushort,[:int, :int, :pointer], :int
  attach_function :nc_put_var_ulonglong,[:int, :int, :pointer], :int
  attach_function :nc_put_vara,[:int, :int,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vara_double,[:int, :int,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vara_float,[:int, :int,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vara_int,[:int, :int,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vara_long,[:int, :int,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vara_schar,[:int, :int,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vara_short,[:int, :int,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vara_string,[:int, :int,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vara_text,[:int, :int,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vara_ubyte,[:int, :int,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vara_uchar,[:int, :int,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vara_uint,[:int, :int,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vara_ulonglong,[:int, :int,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vara_ushort,[:int, :int,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_varm,[:int, :int,:pointer,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_varm_double,[:int, :int,:pointer,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_varm_float,[:int, :int,:pointer,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_varm_int,[:int, :int,:pointer,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_varm_long,[:int, :int,:pointer,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_varm_longlong,[:int, :int,:pointer,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_varm_schar,[:int, :int,:pointer,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_varm_short,[:int, :int,:pointer,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_varm_string,[:int, :int,:pointer,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_varm_text,[:int, :int,:pointer,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_varm_ubyte,[:int, :int,:pointer,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_varm_uchar,[:int, :int,:pointer,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_varm_ulonglong,[:int, :int,:pointer,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_varm_ushort,[:int, :int,:pointer,:pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vars,[:int, :int, :pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vars_double,[:int, :int, :pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vars_float,[:int, :int, :pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vars_int,[:int, :int, :pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vars_long,[:int, :int, :pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vars_longlong,[:int, :int, :pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vars_schar,[:int, :int, :pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vars_short,[:int, :int, :pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vars_string,[:int, :int, :pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vars_text,[:int, :int, :pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vars_uchar,[:int, :int, :pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vars_ubyte,[:int, :int, :pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vars_ushort,[:int, :int, :pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vars_uint,[:int, :int, :pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_put_vars_ulonglong,[:int, :int, :pointer,:pointer,:pointer,:pointer],:int
  attach_function :nc_redef,[:int], :int
  attach_function :nc_rename_att,[:int, :int, :string, :string], :int
  attach_function :nc_rename_dim,[:int, :int, :string], :int
  attach_function :nc_rename_grp,[:int, :string], :int
  attach_function :nc_rename_var,[:int, :int, :string], :int
  attach_function :nc_set_fill,[:int, :int, :pointer], :int
  attach_function :nc_set_var_chunk_cache,[:int, :int, :ulong, :ulong, :float], :int
  attach_function :nc_show_metadata,[:int, :pointer, :pointer], :int
  attach_function :nc_strerror,[:int], :string
  attach_function :nc_sync,[:int], :int
  NC_NAT = 0
  NC_TYPES = {
    1 => :NC_BYTE,
    2 => :NC_CHAR,
    3 => :NC_SHORT,
    4 => :NC_INT,
    5 => :NC_FLOAT,
    6 => :NC_DOUBLE,
    7 => :NC_UBYTE,
    8 => :NC_USHORT,
    9 => :NC_UINT,
    10 => :NC_INT64,
    11 => :NC_UINT64,
    12 => :NC_STRING
  }
  NC_TYPE_IDS = {
    NC_BYTE: 1,
    NC_CHAR: 2,
    NC_SHORT: 3,
    NC_LONG: 4,
    NC_INT: 4,
    NC_FLOAT: 5,
    NC_DOUBLE: 6,
    NC_UBYTE: 7,
    NC_USHORT: 8,
    NC_UINT: 9,
    NC_INT64: 10,
    NC_LONGLONG: 10,
    NC_UINT64: 11,
    NC_STRING: 12
  }
  NC_TYPE_SIZE = {
    NC_BYTE: 1,
    NC_CHAR: 1,
    NC_SHORT: 2,
    NC_INT: 4,
    NC_LONG: 4,
    NC_FLOAT: 4,
    NC_DOUBLE: 8,
    NC_UBYTE: 1,
    NC_USHORT: 2,
    NC_UINT: 4,
    NC_INT64: 8,
    NC_LONGLONG: 8,
    NC_UINT64: 8,
    NC_STRING: 1,
  }
  NC_BYTE = 1
  NC_CHAR = 2
  NC_SHORT = 3
  NC_LONG = 4
  NC_INT = 4
  NC_FLOAT = 5
  NC_DOUBLE = 6
  NC_UBYTE = 7
  NC_USHORT = 8
  NC_UINT = 9
  NC_INT64 = 10
  NC_UINT64 = 11
  NC_STRING = 12
  NC_MAX_ATOMIC_TYPE = 12
  NC_VLEN = 13
  NC_OPAQUE = 14
  NC_ENUM = 15
  NC_COMPOUND= 16
  NC_FIRSTUSERTYPEID = 32
  NC_FILL_BYTE = -127
  NC_FILL_CHAR = 0
  NC_FILL_SHORT = -32767
  NC_FILL_INT = -2147483647
  NC_FILL_FLOAT = 9.9692099683868690e+36
  NC_FILL_DOUBLE = 9.9692099683868690e+36
  NC_FILL_UBYTE = 255
  NC_FILL_USHORT = 65535
  NC_FILL_UINT = 4294967295
  NC_FILL_INT64 = -9223372036854775806
  NC_FILL_UINT64 = 18446744073709551614
  NC_FILL_STRING = ""

  NC_MAX_BYTE = 127
  NC_MIN_BYTE = (-NC_MAX_BYTE-1)
  NC_MAX_CHAR = 255
  NC_MAX_SHORT = 32767
  NC_MIN_SHORT = (-NC_MAX_SHORT - 1)
  NC_MAX_INT = 2147483647
  NC_MIN_INT = (-NC_MAX_INT - 1)
  NC_MAX_FLOAT = 3.402823466e+38
  NC_MIN_FLOAT = (-NC_MAX_FLOAT)
  NC_MAX_DOUBLE = 1.7976931348623157e+308
  NC_MIN_DOUBLE = (-NC_MAX_DOUBLE)
  NC_MAX_UBYTE = NC_MAX_CHAR
  NC_MAX_USHORT = 65535
  NC_MAX_UINT = 4294967295
  NC_MAX_INT64 = (9223372036854775807)
  NC_MIN_INT64 = (-9223372036854775807-1)
  NC_MAX_UINT64 = (18446744073709551615)
  X_INT64_MAX =  (9223372036854775807)
  X_INT64_MIN =  (-X_INT64_MAX - 1)
  X_UINT64_MAX = (18446744073709551615)
  NC_FILL = 0
  NC_NOFILL = 0x100

  NC_NOWRITE = 0x0000	#/**< Set read-only access for nc_open(). */
  NC_WRITE = 0x0001	#/**< Set read-write access for nc_open(). */
  NC_CLOBBER = 0x0000 #/**< Destroy existing file. Mode flag for nc_create(). */
  NC_NOCLOBBER = 0x0004	#/**< Don't destroy existing file. Mode flag for nc_create(). */

  NC_DISKLESS = 0x0008 #/**< Use diskless file. Mode flag for nc_open() or nc_create(). */
  NC_MMAP = 0x0010 #/**< Use diskless file with mmap. Mode flag for nc_open() or nc_create(). */

  NC_CLASSIC_MODEL = 0x0100 #/**< Enforce classic model. Mode flag for nc_create(). */
  NC_64BIT_OFFSET  = 0x0200 #/**< Use large (64-bit) file offsets. Mode flag for nc_create(). */
  NC_LOCK = 0x0400

  NC_SHARE = 0x0800
  NC_NETCDF4 = 0x1000 #/**< Use netCDF-4/HDF5 format. Mode flag for nc_create(). */
  NC_MPIIO = 0x2000
  NC_MPIPOSIX = 0x4000 #/**< \deprecated As of libhdf5 1.8.13. */
  NC_PNETCDF = 0x8000	#/**< Use parallel-netcdf library. Mode flag for nc_open(). */
  NC_FORMAT_CLASSIC = 1
  NC_FORMAT_64BIT = 2
  NC_FORMAT_NETCDF4 = 3
  NC_FORMAT_NETCDF4_CLASSIC = 4
  NC_FORMAT_NC3 = 1
  NC_FORMAT_NC_HDF5 = 2 #/* netCDF-4 subset of HDF5 */
  NC_FORMAT_NC_HDF4 = 3 #/* netCDF-4 subset of HDF4 */
  NC_FORMAT_PNETCDF = 4
  NC_FORMAT_DAP2 = 5
  NC_FORMAT_DAP4 = 6
  NC_FORMAT_UNDEFINED = 0
  NC_SIZEHINT_DEFAULT = 0
  NC_UNLIMITED = 0
  NC_GLOBAL = -1
  NC_MAX_DIMS = 1024
  NC_MAX_ATTRS = 8192
  NC_MAX_VARS = 8192
  NC_MAX_NAME = 256
  NC_MAX_VAR_DIMS = 1024 #/**< = max = per = variable = dimensions = */
  NC_MAX_HDF4_NAME = 64
  NC_ENDIAN_NATIVE = 0
  NC_ENDIAN_LITTLE = 1
  NC_ENDIAN_BIG = 2
  NC_CHUNKED = 0
  NC_CONTIGUOUS = 1
  NC_NOCHECKSUM = 0
  NC_FLETCHER32 = 1
  NC_NOERR	= 0 #/**< = No = Error = */
  NC2_ERR = -1 #/**< = Returned = for = all = errors = in = the = v2 = API. = */
  NC_EBADID = -33
  NC_ENFILE = -34  #/**< = Too = many = netcdfs = open = */
  NC_EEXIST = -35  #/**< = netcdf = file = exists = && = NC_NOCLOBBER = */
  NC_EINVAL = -36  #/**< = Invalid = Argument = */
  NC_EPERM  = -37  #/**< = Write = to = read = only = */
  NC_EINDEFINE = -39
  NC_EINVALCOORDS = -40
  NC_EMAXDIMS = -41  #/**< = NC_MAX_DIMS = exceeded = */
  NC_ENAMEINUSE = -42  #/**< = String = match = to = name = in = use = */
  NC_ENOTATT = -43  #/**< = Attribute = not = found = */
  NC_EMAXATTS = -44  #/**< = NC_MAX_ATTRS = exceeded = */
  NC_EBADTYPE = -45  #/**< = Not = a = netcdf = data = type = */
  NC_EBADDIM = -46  #/**< = Invalid = dimension = id = or = name = */
  NC_EUNLIMPOS = -47  #/**< = NC_UNLIMITED = in = the = wrong = index = */

  NC_ENOTVAR = -49
  NC_EGLOBAL = -50  #/**< = Action = prohibited = on = NC_GLOBAL = varid = */
  NC_ENOTNC = -51  #/**< = Not = a = netcdf = file = */
  NC_ESTS = -52  #/**< = In = Fortran, = string = too = short = */
  NC_EMAXNAME =  -53  #/**< = NC_MAX_NAME = exceeded = */
  NC_EUNLIMIT =  -54  #/**< = NC_UNLIMITED = size = already = in = use = */
  NC_ENORECVARS =  -55  #/**< = nc_rec = op = when = there = are = no = record = vars = */
  NC_ECHAR = -56  #/**< = Attempt = to = convert = between = text = & = numbers = */
  NC_EEDGE = -57
  NC_ESTRIDE = -58  #/**< = Illegal = stride = */
  NC_EBADNAME = -59  #/**< = Attribute = or = variable = name = contains = illegal = characters = */
  NC_ERANGE = -60
  NC_ENOMEM = -61  #/**< = Memory = allocation = (malloc) = failure = */
  NC_EVARSIZE = -62 #/**< = One = or = more = variable = sizes = violate = format = constraints = */
  NC_EDIMSIZE = -63 #/**< = Invalid = dimension = size = */
  NC_ETRUNC = -64 #/**< = File = likely = truncated = or = possibly = corrupted = */
  NC_EAXISTYPE = -65 #/**< = Unknown = axis = type. = */
  NC_EDAP = -66 #/**< = Generic = DAP = error = */
  NC_ECURL = -67 #/**< = Generic = libcurl = error = */
  NC_EIO = -68 #/**< = Generic = IO = error = */
  NC_ENODATA = -69 #/**< = Attempt = to = access = variable = with = no = data = */
  NC_EDAPSVC = -70 #/**< = DAP = server = error = */
  NC_EDAS = -71 #/**< = Malformed = or = inaccessible = DAS = */
  NC_EDDS = -72 #/**< = Malformed = or = inaccessible = DDS = */
  NC_EDATADDS = -73 #/**< = Malformed = or = inaccessible = DATADDS = */
  NC_EDAPURL = -74 #/**< = Malformed = DAP = URL = */
  NC_EDAPCONSTRAINT = -75 #/**< = Malformed = DAP = Constraint*/
  NC_ETRANSLATION = -76 #/**< = Untranslatable = construct = */
  NC_EACCESS = -77 #/**< = Access = Failure = */
  NC_EAUTH = -78 #/**< = Authorization = Failure = */
  NC_ENOTFOUND = -90 #/**< = No = such = file = */
  NC_ECANTREMOVE = -91 #/**< = Can't = remove = file = */
  NC4_FIRST_ERROR = -100
  NC_EHDFERR = -101
  NC_ECANTREAD = -102 #/**< = Can't = read. = */
  NC_ECANTWRITE = -103 #/**< = Can't = write. = */
  NC_ECANTCREATE = -104 #/**< = Can't = create. = */
  NC_EFILEMETA = -105 #/**< = Problem = with = file = metadata. = */
  NC_EDIMMETA = -106 #/**< = Problem = with = dimension = metadata. = */
  NC_EATTMETA = -107 #/**< = Problem = with = attribute = metadata. = */
  NC_EVARMETA = -108 #/**< = Problem = with = variable = metadata. = */
  NC_ENOCOMPOUND = -109 #/**< = Not = a = compound = type. = */
  NC_EATTEXISTS = -110 #/**< = Attribute = already = exists. = */
  NC_ENOTNC4 = -111 #/**< = Attempting = netcdf-4 = operation = on = netcdf-3 = file. = */

  NC_ESTRICTNC3 = -112
  NC_ENOTNC3 = -113 #/**< = Attempting = netcdf-3 = operation = on = netcdf-4 = file. = */
  NC_ENOPAR = -114 #/**< = Parallel = operation = on = file = opened = for = non-parallel = access. = */
  NC_EPARINIT = -115 #/**< = Error = initializing = for = parallel = access. = */
  NC_EBADGRPID = -116 #/**< = Bad = group = ID. = */
  NC_EBADTYPID = -117 #/**< = Bad = type = ID. = */
  NC_ETYPDEFINED = -118 #/**< = Type = has = already = been = defined = and = may = not = be = edited. = */
  NC_EBADFIELD = -119 #/**< = Bad = field = ID. = */
  NC_EBADCLASS = -120 #/**< = Bad = class. = */
  NC_EMAPTYPE = -121 #/**< = Mapped = access = for = atomic = types = only. = */
  NC_ELATEFILL = -122 #/**< = Attempt = to = define = fill = value = when = data = already = exists. = */
  NC_ELATEDEF = -123 #/**< = Attempt = to = define = var = properties, = like = deflate, = after = enddef. = */
  NC_EDIMSCALE = -124 #/**< = Probem = with = HDF5 = dimscales. = */
  NC_ENOGRP = -125 #/**< = No = group = found. = */
  NC_ESTORAGE = -126 #/**< = Can't = specify = both = contiguous = and = chunking. = */
  NC_EBADCHUNK = -127 #/**< = Bad = chunksize. = */
  NC_ENOTBUILT = -128 #/**< = Attempt = to = use = feature = that = was = not = turned = on = when = netCDF = was = built. = */
  NC_EDISKLESS = -129 #/**< = Error = in = using = diskless = access. = */
  NC_ECANTEXTEND = -130 #/**< = Attempt = to = extend = dataset = during = ind. = I/O = operation. = */
  NC_EMPI = -131 #/**< = MPI = operation = failed. = */

  NC4_LAST_ERROR = -131

  DIM_WITHOUT_VARIABLE = "This is a netCDF dimension but not a netCDF variable."

  NC_HAVE_NEW_CHUNKING_API = 1

  NC_EURL = NC_EDAPURL #/* = Malformed = URL = */
  NC_ECONSTRAINT = NC_EDAPCONSTRAINT #/* = Malformed = Constraint*/  
end

$ignoreError = [FFINetCDF::NC_ENAMEINUSE, FFINetCDF::NC_EHDFERR]
$debug = nil
def ncerr(r, prefix = "[]", line = nil, on_error: nil, on_ok: nil,  &block)
  if $ignoreError.include?(r) then
    on_ok.call if on_ok
    block.call if block
    return false
  end
  if r != FFINetCDF::NC_NOERR then
    STDERR.puts("#{prefix}:#{line}:(#{r}) - #{FFINetCDF.nc_strerror(r)}") if $debug
    #block.call if block and on_error
    on_error.call if on_error
    block.call if block 
    return true
  end
  on_ok.call if on_ok
  block.call if block 
  return false
end
def puta(*args)
  puts args.to_s
end
def failed(value, log)
  if (not value)  then
    log.call if log.class == Proc
    puts log if log.class != Proc
    return true
  end
  return false
end

class Array
  def regroup(n)
    ng = self.length/n
    out = []
    for i in 0...ng do
      out << self[i*n,n]
    end
    out
  end
end
class Hash
  def map(&block)
    h = {}
    self.each_pair do | k, v|
      a,b = block.call(k, v)
      h[a] = b
    end
    h
  end
  def map_to_array(&block)
    a = []
    self.each_pair do | k, v|
      r = block.call(k, v)
      a << r
    end
    a
  end
end
def swap(a, b, chk)
  if chk.call(a, b) then
    return b, a, true
  end
  return a, b, false
end
