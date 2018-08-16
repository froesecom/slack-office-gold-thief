class OfficeGoldThief::Utilities::UserInfo

  def initialize(driver)
    @driver = driver
  end

  def get_status(slack_user=nil)
    remove_existing_status_elements
    sleep 1
    request_status
    parse_status
  end

  private
  def parse_status
    message_text_field_class = 'c-message_attachment__text'
    wait = Selenium::WebDriver::Wait.new(timeout: 10) # seconds
    wait.until {
      @driver.find_elements(class: message_text_field_class)
    }
    status_el = @driver.find_elements(class: message_text_field_class).last
    status = status_el.text if status_el
    parse_status_text(status)
  end

  def parse_status_text(text=nil)
    return {error: "could not retrieve status from element"} unless text
    text_array = text.split("\n")
    gold = text_array[0].to_i
    energy = text_array[1].to_f if text_array[1]
    {gold: gold, energy: energy}
  end

  def request_status(slack_user=nil)
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
