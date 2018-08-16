class OfficeGoldThief::Tracker

  def initialize(info_utility, slack_user=nil)
    @info_utility = info_utility
    @slack_user = slack_user
  end

  def track_action(action)
    @info_utility.get_status
    action.call
    #remove_info_elements
    # write messanger
    #wait = Selenium::WebDriver::Wait.new(timeout: 10) # seconds
    #wait.until { driver.find_element(class: "ql-editor") }
  end

end
