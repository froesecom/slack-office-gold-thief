class OfficeGoldThief::DefaultAction < OfficeGoldThief::Action
  class InvalidModeError < StandardError; end;

  @@modes = {
    silent: {timeout: 240},
    medium: {timeout: 480},
    berserk: {timeout: 960}
  }

  def initialize(mode=:silent)
    @mode = mode
    validate_mode
  end

  private
  def validate_mode
    modes = @@modes.keys
    unless modes.include? @mode
      raise InvalidModeError.new("#{@mode} is not a valid mode for this action. Try one of #{modes}")
    end
  end

end
