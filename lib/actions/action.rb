class OfficeGoldThief::Action
  class MissingChildMethodError < StandardError; end;

  attr_accessor :driver, :user_to_raid

  def call(options=nil)
    raise_missing_child_method("call")
  end

  def timeout
    raise_missing_child_method("timeout")
  end

  private
  def raise_missing_child_method(method_name)
    raise MissingChildMethodError.new("The #{method_name} method must be implemented in a child class")
  end

end
