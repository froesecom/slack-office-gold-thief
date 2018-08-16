class OfficeGoldThief::Utilities::Messenger

  def self.submit_message(driver, message)
    driver.execute_script("document.querySelectorAll('#msg_input p')[0].innerHTML = '#{message}'")
    driver.action.send_keys(:enter).perform
  end
end

