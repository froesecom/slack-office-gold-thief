module OfficeGoldThief::Authenticator

  def self.login(driver, email, password)
    email_input = driver.find_element(name: 'email')
    email_input.send_keys email
    password_input = driver.find_element(name: 'password')
    password_input.send_keys password
    password_input.submit

    wait = Selenium::WebDriver::Wait.new(timeout: 10) # seconds
    wait.until { driver.find_element(class: "ql-editor") }

  end

end
