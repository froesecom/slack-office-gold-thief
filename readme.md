# Slack Office Gold Thief

A script to raid your friends' gold via the [Office Gold Slack](http://officegold.fruktorum.com/office_gold) app

## To run

`./run.rb`

## To quit

`ctl + c`

## Usage

Office Gold has three raiding "modes": silent, medium, berserk. The default mode for this script is to raid in `silent` mode. You can switch to one of the other modes by adding the corresponding symbol to `OfficeGoldThief::DefaultAction.new(:berserk)` in `run.rb`.

If you want to write your own custom raiding logic, simply create a custom action class in `/lib/actions/custom/` and replace the default action with your action in `run.rb`. Your action must inherit from `OfficeGoldThief::Action`. By doing so, you'll have access to the selenium `driver` and `user_to_raid` in your Action class. See the `lib/actions/default/default_action.rb` for examples.

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
- `./geckodriver-install.sh`
