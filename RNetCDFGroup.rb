require 'FFINetCDF'
require 'RNCUtil'
require 'RNCDelegate'
class RNetCDFGroup
  attr_reader :ncid, :gid, :name
  def initialize(ncid, name)
    @ncid = ncid
    if name != "/" then
      if(not @gid = RNCUtil.groupIdForName(name, ncid)) then
        puts "Create Group: #{name}"
        if(not @gid = RNCUtil.createGroup(name, ncid)) then
          return nil
        end
      end
    else
      @gid = nil
    end
    @name = name
    return self
  end
  def apply(&block)
    block.call(self)
  end
  def dimension(name = nil)
    if not name then
      return RNCDelegate.new(@ncid, @gid, :dimension)
    else
      return RNetCDFDimension.new(@ncid, @gid, name)
    end
  end
  def group(name = nil)
    if not name then
      return RNCDelegate.new(@ncid, @gid, :group)
    else
      return RNetCDFGroup.new(@gid, name)
    end
  end
  def variable(name = nil)
    if not name then
      return RNCDelegate.new(@ncid, @gid, :variable)
    else
      return RNetCDFVariable.new(@gid ? @gid : @ncid, name)
    end
  end
  def attribute(name = nil)
    if not name then
      return RNCDelegate.new(@gid ? @gid : @ncid, nil, :attribute)
    else
      return RNetCDFAttribute.new(@gid ? @gid : @ncid, nil, name)
    end
  end
  def attributes
    return {} if not @ncid and not @gid
    RNCUtil.getAllAttributes(@gid ? @gid : @ncid, nil)
  end
  def groups
    return {} if not @ncid and not @gid
    RNCUtil.getAllGroups(@gid ? @gid : @ncid)
  end
  def variables
    return {} if not @ncid and not @gid
    RNCUtil.getAllVariables(@gid ? @gid : @ncid)
  end
end
