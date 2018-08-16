class OfficeGoldThief::Tracker

  attr_reader :slack_user, :initial_gold, :initial_energy
  def initialize(info_utility, slack_user=nil)
    @info_utility = info_utility
    @slack_user = slack_user
    set_initial_state
  end

  def track_action(action)
    @info_utility.get_status
    action.call
    #remove_info_elements
    # write messanger
    #wait = Selenium::WebDriver::Wait.new(timeout: 10) # seconds
    #wait.until { driver.find_element(class: "ql-editor") }
  end

  private
  def set_initial_state
    status = @info_utility.get_status
    @initial_gold = status[:gold]
    @initial_energy = status[:energy]
    puts @initial_gold
    puts @initial_energy
    #raise error if error in status
    #create logger thingo to log this stuff
  end
end
