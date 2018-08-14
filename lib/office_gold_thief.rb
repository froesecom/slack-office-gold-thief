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

    @driver.navigate.to @config["channel_to_raid_in"]

    Authenticator.login(@driver, @config["login_email"], @config["login_password"])

    input = @driver.find_element(id: "msg_input")
    sleep 5
    input.click
    sleep 1

    while true
      @tracker.track
      @action.call
      @tracker.track
    end

    @driver.quit
  end

  private
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
