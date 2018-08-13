require 'rubygems'
require 'bundler/setup'
require 'selenium-webdriver'
require 'yaml'
require 'pry'

module OfficeGoldThief
  def self.call(mode="silent")
    config = YAML.load(File.read("config.yml"))
    mode_conf = config["modes"][mode]

    task = "raid @#{config["user_to_raid"]} #{mode}"
    driver = Selenium::WebDriver.for :firefox
    driver.navigate.to config["channel_to_raid_in"]

    email_input = driver.find_element(name: 'email')
    email_input.send_keys config["login_email"]
    password_input = driver.find_element(name: 'password')
    password_input.send_keys config["login_password"]
    password_input.submit

    wait = Selenium::WebDriver::Wait.new(timeout: 10) # seconds
    wait.until { driver.find_element(class: "ql-editor") }

    input = driver.find_element(id: "msg_input")
    sleep 5
    input.click

    while true
      driver.execute_script("document.querySelectorAll('#msg_input p')[0].innerHTML = '#{task}'")
      driver.action.send_keys(:enter).perform
      sleep mode_conf["timeout"]
    end

    driver.quit
  end
end

require_relative 'services/tracker'
