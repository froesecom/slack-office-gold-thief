# Slack Office Gold Thief

A script to raid your friends' gold via the Office [Gold Slack](http://officegold.fruktorum.com/office_gold) app

## To run

`./run.rb`

## To quit

`ctl + c`

## To install

This app currently uses Selenium's Firefox driver to launch a browser instance and raid your buddies gold.

- `bundle install`
- install Firefox driver (see below)
- copy `config.yml.example` to `config.yml`
- Fill in `config.yml` with your details.

#### Installing Firefox driver

You can either install the [geckodriver manually](https://github.com/mozilla/geckodriver/releases), or use the included install script.

Currently to use the install script, you need to:

- install the [jq tool](https://stedolan.github.io/jq/)
- create a `geckodriver` folder in the directory you're running the script (it will be automatically moved
