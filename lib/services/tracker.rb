class OfficeGoldThief::Tracker

  def initialize(driver, slack_user=nil)
    @driver = driver
    @slack_user = slack_user
  end

  def track_action(action)
    action.call
    #remove_info_elements
    # write messanger
    #wait = Selenium::WebDriver::Wait.new(timeout: 10) # seconds
    #wait.until { driver.find_element(class: "ql-editor") }
  end

  private
  def remove_info_elements
    script = "
               var els = document.getElementsByClassName('c-message_attachment__text');
               for (var i=0;i < els.length;i++) {
                 els[i].parentNode.removeChild(els[i]);
               }
             "
    @driver.execute_script(script)
  end

end
