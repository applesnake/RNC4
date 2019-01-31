require 'FFINetCDF'
require 'RNCUtil'
require 'RNCDelegate'
require 'RNetCDF'
require 'RNetCDFGroup'

require 'numo/narray'

data = Numo::Int16.new([20,30]).fill(255)
data2d = Numo::Int32.new([10,30]).fill(255)
data3d = Numo::SFloat.new([10,30,30]).fill(1)
rnc = RNetCDF.new.open("./t-group.nc", :overwrite)
rnc.dimension.x = 30
rnc.dimension.z = 10
rnc.group.testGroup01.apply do | grp |
  grp.dimension.x = 30
  grp.dimension.y = 20
  grp.dimension.z = 10
  grp.variable.f2d.apply do | var |
    var.put(data, ["y", "x"])
    var.attribute.info = "HAHAHAHAH"
  end
  grp.variable.f3d.put(data3d, ["z", "x", "x"]).attribute.info = "Yes"
  grp.attribute.f3dInfo = "ABC"
end
rnc.attribute.globalAtt = "Hello"
rnc.attribute.intAtt = 100
rnc.attribute.floatAtt = 1024.0
rnc.attribute.arrayAtt = [1024.0, 100.0]

rnc.variable.intValues.put(data2d, ["z", "x"])

rnc.close if rnc

