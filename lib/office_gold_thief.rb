require 'rubygems'
require 'bundler/setup'
require 'selenium-webdriver'
require 'yaml'
require 'pry'

class OfficeGoldThief

  attr_reader :driver

  def initialize
    @driver = Selenium::WebDriver.for :firefox
  end

  def call(mode="silent")
    config = YAML.load(File.read("config.yml"))
    mode_conf = config["modes"][mode]
    task = "raid @#{config["user_to_raid"]} #{mode}"
    tracker = Tracker.new(@driver)

    @driver.navigate.to config["channel_to_raid_in"]

    Authenticator.login(@driver, config["login_email"], config["login_password"])

    wait = Selenium::WebDriver::Wait.new(timeout: 10) # seconds
    wait.until { @driver.find_element(class: "ql-editor") }

    input = @driver.find_element(id: "msg_input")
    sleep 5
    input.click
    sleep 1

    while true
      tracker.track
      @driver.execute_script("document.querySelectorAll('#msg_input p')[0].innerHTML = '#{task}'")
      @driver.action.send_keys(:enter).perform
      sleep mode_conf["timeout"]
    end

    @driver.quit
  end
end

require_relative 'services/authenticator'
require_relative 'services/tracker'
