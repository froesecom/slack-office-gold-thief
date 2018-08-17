class OfficeGoldThief::Utilities::UserInfo
  class StatusRequestError < StandardError; end;

  def initialize(driver)
    @driver = driver
  end

  def get_status(slack_user=nil, tries=0)
    unless tries > 4
      remove_existing_status_elements
      sleep 1
      request_status(slack_user)
      parse_status(slack_user, tries)
    else
      raise_request_error("Unable to successfully find current status for #{slack_user ? slack_user : 'yourself'}")
    end
  end

  private
  def is_valid_status(status)
    status.include? "gold"
  end

  def parse_status(slack_user, tries)
    message_text_field_class = 'c-message_attachment__text'
    wait = Selenium::WebDriver::Wait.new(timeout: 10) # seconds
    wait.until {
      @driver.find_elements(class: message_text_field_class)
    }
    status_el = @driver.find_elements(class: message_text_field_class).last
    status = status_el.text if status_el
    if is_valid_status(status)
    parse_status_text(status)
    else
      sleep 1
      tries += 1
      get_status(slack_user, tries)
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
    script = "
               var els = document.getElementsByClassName('c-message_attachment__text');
               for (var i=0;i < els.length;i++) {
                 els[i].parentNode.removeChild(els[i]);
               }
             "
    @driver.execute_script(script)
  end


end
