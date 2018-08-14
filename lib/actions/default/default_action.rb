class OfficeGoldThief::DefaultAction < OfficeGoldThief::Action
  class InvalidModeError < StandardError; end;

  @@modes = {
    silent: {timeout: 240},
    medium: {timeout: 480},
    berserk: {timeout: 960}
  }

  def initialize(mode=:silent)
    @mode = mode
    @timeout = @@modes[@mode][:timeout]
    validate_mode
  end

  def call
    task = "raid @#{user_to_raid} #{@mode.to_s}"
    driver.execute_script("document.querySelectorAll('#msg_input p')[0].innerHTML = '#{task}'")
    driver.action.send_keys(:enter).perform
    sleep @timeout
  end

  private
  def validate_mode
    modes = @@modes.keys
    unless modes.include? @mode
      raise InvalidModeError.new("#{@mode} is not a valid mode for this action. Try one of #{modes}")
    end
  end

end
