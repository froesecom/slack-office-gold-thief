class OfficeGoldThief::Utilities::UserInfo
  class StatusRequestError < StandardError; end;

  def initialize(driver)
    @driver = driver
    @message_text_field_class = 'c-message_attachment__text'
  end

  def get_status(slack_user=nil)
    remove_existing_status_elements
    request_status(slack_user)
    parse_status(slack_user)
  end

  private
  def is_valid_status(status)
    status.include? "gold"
  end

  def parse_status(slack_user, tries=0)
    # refactor
    unless tries > 4
      wait = Selenium::WebDriver::Wait.new(timeout: 10) # seconds
      wait.until {
        @driver.find_elements(class: @message_text_field_class)
      }
      statuses = @driver.find_elements(class: @message_text_field_class)
      status_el = statuses.last
      status = status_el.text if status_el
      puts tries
      if status && is_valid_status(status)
        parse_status_text(status)
      else
        sleep 1
        tries += 1
        parse_status(slack_user, tries)
      end
    else
      raise_request_error("Unable to successfully find current status for #{slack_user ? slack_user : 'yourself'}")
    end
  end

  def parse_status_text(text=nil)
    return {error: "could not retrieve status from element"} unless text
    text_array = text.split("\n")
    gold = text_array[0].to_i
    energy = text_array[1].to_f if text_array[1]
    {gold: gold, energy: energy}
  end

  def raise_request_error(message)
    raise StatusRequestError.new(message)
  end

  def request_status(slack_user)
    message = slack_user ? "info @#{slack_user}" : "info"
    OfficeGoldThief::Utilities::Messenger.submit_message(@driver, message)
  end

  def remove_existing_status_elements
    info_fields = @driver.find_elements(class: @message_text_field_class)
    script = "arguments[0].setAttribute('class', '')"
    info_fields.each do |f|
      @driver.execute_script(script, f)
    end
    sleep 2 # magic number to ensure everything is removed; refactor
  end

end
