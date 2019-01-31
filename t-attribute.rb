require 'FFINetCDF'
require 'RNCUtil'
require 'RNetCDF'
require 'numo/narray'

rnc = RNetCDF.new.open("./t-group.nc", :readonly)
att = rnc.attributes
grps = rnc.groups
vars = rnc.variables
att.each do | a |
  puts a.value.to_s
end
puts grps.to_s
puts grps[0].variables.to_s
#puts vars.to_s
rnc.close if rnc

