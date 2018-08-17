class OfficeGoldThief::Tracker

  attr_reader :slack_user, :initial_gold, :initial_energy
  def initialize(info_utility, slack_user=nil)
    @info_utility = info_utility
    @slack_user = slack_user
    @change_in_gold = 0
    @change_in_energy = 0.00
    set_initial_state
  end

  def track_action(action)
    status = @info_utility.get_status
    action.call
    new_status = @info_utility.get_status
    set_status_change(status, new_status)
    sleep action.timeout
  end

  private
  def set_initial_state
    status = @info_utility.get_status
    @initial_gold = status[:gold]
    @initial_energy = status[:energy]
    @start_time = Time.now.to_i
  end

  def set_status_change(status_1, status_2)
    @change_in_gold += (status_2[:gold] - status_1[:gold])
    @change_in_energy += (@initial_energy  - status_1[:energy])
    puts "@change_in_gold #{@change_in_gold}; @change_in_energy #{@change_in_energy}"
  end
end
