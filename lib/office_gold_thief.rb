require 'rubygems'
require 'bundler/setup'
require 'pry'
require 'yaml'
require 'require_all'
require 'selenium-webdriver'

class OfficeGoldThief

  class InvalidActionError < StandardError; end;

  attr_reader :driver

  def initialize(action)
    @action = action
    validate_action
    @driver = Selenium::WebDriver.for :firefox
    @action.driver = @driver
    @config = YAML.load(File.read("config.yml"))
  end

  def call

    mode = "silent"
    mode_conf = @config["modes"][mode]
    task = "raid @#{@config["user_to_raid"]} #{mode}"
    tracker = Tracker.new(@driver)

    @driver.navigate.to @config["channel_to_raid_in"]

    Authenticator.login(@driver, @config["login_email"], @config["login_password"])

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

  private
  def validate_action
    unless @action.class.ancestors.include? OfficeGoldThief::Action
      raise InvalidActionError.new("Your action instance must inherit from OfficeGoldThief::Action class")
    end
  end

end

require_all 'lib/actions'
require_all 'lib/services'
