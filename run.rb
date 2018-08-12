#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require "selenium-webdriver"

task = "raid @USERNAME medium"

driver = Selenium::WebDriver.for :firefox
driver.navigate.to "SLACK CHANNEL URL"

email_input = driver.find_element(name: 'email')
email_input.send_keys "LOGIN EMAIL"
password_input = driver.find_element(name: 'password')
password_input.send_keys "LOGIN PASSWORD"
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

