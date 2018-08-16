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
    @driver = Selenium::WebDriver.for :firefox
    @config = YAML.load(File.read("config.yml"))
    @user_to_raid = @config["user_to_raid"]
    setup_action
    @tracker = Tracker.new(@driver)
  end

  def call
    navigate_to_channel
    login
    focus_on_message_input

    while true
      @tracker.track_action(@action)
    end

    @driver.quit
  end

  private
  def focus_on_message_input
    input = @driver.find_element(id: "msg_input")
    sleep 5 #magic number... to avoid a pop up, needs refactor
    input.click
    sleep 1 #wait for focus before calling actions
  end

  def login
    Authenticator.login(@driver, @config["login_email"], @config["login_password"])
  end

  def navigate_to_channel
    @driver.navigate.to @config["channel_to_raid_in"]
  end

  def setup_action
    validate_action
    @action.driver = @driver
    @action.user_to_raid = @user_to_raid
  end

  def validate_action
    unless @action.class.ancestors.include? OfficeGoldThief::Action
      raise InvalidActionError.new("Your action instance must inherit from OfficeGoldThief::Action class")
    end
  end

end

require_all 'lib/actions'
require_all 'lib/services'
require_all 'lib/utilities'
