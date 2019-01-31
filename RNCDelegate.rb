require 'RNetCDFGroup'
require 'RNetCDFVariable'
require 'RNetCDFAttribute'
require 'RNetCDFDimension'
class RNCDelegate
  def initialize(ncid, oid, *args)
    @ncid = ncid
    @oid = oid
    @grp = (args[0] == :group)
    @var = (args[0] == :variable)
    @att = (args[0] == :attribute)
    @dim = (args[0] == :dimension)
    @name = args[1]
    if @name then
      return RNetCDFGroup.new(@ncid, @name) if @grp
      return RNetCDFVariable.new(@ncid, @name) if @var
      return RNetCDFAttribute.new(@ncid,@oid,@name) if @att
      return RNetCDFDimension.new(@ncid,@oid,@name) if @dim
    else
      return self
    end
  end
  def method_missing(sym, *args, &block)
    ss = sym.to_s
    name = nil
    if ss[-1] == "=" then
      name = ss[0, ss.length-1]
    else
      name = ss
    end
    obj = nil
    if @grp then
      gid = @oid ? @oid : @ncid
      obj = RNetCDFGroup.new(gid, name)
      return nil if not obj
      
      if ss[-1] == "=" then
        op = "RetCDFGroup=".to_sym
        return obj.send(op, *args, &block)
      end
    elsif @var then
      #puts "DEBUG #{@ncid}, #{@oid}"
      gid = @oid ? @oid : @ncid
      obj =  RNetCDFVariable.new(gid, name)
      return nil if not obj
      if ss[-1] == "=" then
        op = "RetCDFVariable=".to_sym
        return obj.send(op, *args, &block)
      end
    elsif @att then
      obj = RNetCDFAttribute.new(@ncid, @oid, name)
      return nil if not obj
      if ss[-1] == "=" then
        op = "RNetCDFAttribute=".to_sym
        return obj.send(op, *args, &block)
      end
    elsif @dim then
      obj = RNetCDFDimension.new(@ncid, @oid, name)
      return nil if not obj
      if ss[-1] == "=" then
        op = "RNetCDFDimension=".to_sym
        return obj.send(op, *args, &block)
      end
    end
    return obj
  end
end
