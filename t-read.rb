require 'FFINetCDF'
require 'RNCUtil'
require 'RNCDelegate'
require 'RNetCDF'
require 'RNetCDFGroup'

require 'numo/narray'

data = Numo::Int16.new([20,30]).fill(255)
data2d = Numo::Int32.new([10,30]).fill(255)
data3d = Numo::SFloat.new([10,30,30]).fill(1)
rnc = RNetCDF.new.open("./t-group.nc", :readonly)
na = rnc.variable("intValues").to_narray
puts na.to_a.to_s

rnc.close if rnc

