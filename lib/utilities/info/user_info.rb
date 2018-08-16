class OfficeGoldThief::Utilities::UserInfo

  def initialize(driver)
    @driver = driver
  end

  def get_status(slack_user=nil)
    remove_existing_status_elements
    request_status
    #parse_status
  end

  private
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
