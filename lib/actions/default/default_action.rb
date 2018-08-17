class OfficeGoldThief::DefaultAction < OfficeGoldThief::Action
  class InvalidModeError < StandardError; end;

  @@modes = {
    silent: {timeout: 240},
    medium: {timeout: 480},
    berserk: {timeout: 960}
  }

  attr_reader :timeout
  def initialize(mode=:silent)
    @mode = mode
    @timeout = @@modes[@mode][:timeout]
    validate_mode
  end

  def call
    task = "raid @#{user_to_raid} #{@mode.to_s}"
    OfficeGoldThief::Utilities::Messenger.submit_message(driver, task)
  end

  private
  def validate_mode
    modes = @@modes.keys
    unless modes.include? @mode
      raise InvalidModeError.new("#{@mode} is not a valid mode for this action. Try one of #{modes}")
    end
  end

end
