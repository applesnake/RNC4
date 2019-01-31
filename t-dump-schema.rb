require 'FFINetCDF'
require 'RNCUtil'
require 'RNetCDF'

rnc = RNetCDF.new.open("./t-group.nc", :readonly)
ret = RNCUtil.dumpNCSchema(rnc.ncid)
puts ret
rnc2 = RNetCDF.new.open("./t-group-like.nc", :readwrite, :overwrite)
RNCUtil.createNewFileWithSchema(ret, rnc2)
rnc.close


