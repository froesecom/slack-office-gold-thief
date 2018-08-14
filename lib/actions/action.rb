class OfficeGoldThief::Action
  class MissingChildMethodError < StandardError; end;

  attr_accessor :driver

  def call(options=nil)
    raise_missing_child_method("call")
  end

  private
  def raise_missing_child_method(method_name)
    raise MissingChildMethodError.new("The #{method_name} method must be implemented in a child class")
  end

end
