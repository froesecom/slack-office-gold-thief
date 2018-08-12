#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'selenium-webdriver'
require 'yaml'
require 'pry'

config = YAML.load(File.read("config.yml"))

task = "raid @#{config["user_to_raid"]} medium"
driver = Selenium::WebDriver.for :firefox
driver.navigate.to config["channel_to_raid_in"]

email_input = driver.find_element(name: 'email')
email_input.send_keys config["login_email"]
password_input = driver.find_element(name: 'password')
password_input.send_keys config["login_password"]
password_input.submit

wait = Selenium::WebDriver::Wait.new(timeout: 10) # seconds
wait.until { driver.find_element(class: "ql-editor") }
#input = driver.find_element(id: "msg_input")
#p = input.find_element(css: "p")

input = driver.find_element(id: "msg_input")
sleep 5
input.click

while true
  driver.execute_script("document.querySelectorAll('#msg_input p')[0].innerHTML = '#{task}'")
  driver.action.send_keys(:enter).perform
  sleep 480
end


driver.quit

