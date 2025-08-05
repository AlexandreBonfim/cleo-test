# Cleo Change Calculator Exercise

This is a bootstrap repo for running the cleo change calculator exercise which is part of our backend hiring process.

## Installation

Execute:

    $ bundle install

To get everything going.  Should work with most newish rubies as we've not specificed an explicit one.  Although it was bundled with bundler 2.1.4 so you'll probably need at least bundler 2.x.

## Usage

There's an empty class `ChangeCalculator` in `lib/change_calculator.rb`, this is where we expect you to put the code.  We've set up both rspec and minitest for you to bootstrap testing, pick whichever you prefer most.  You can run minitest via:

    $ bundle exec rake test

and rspec via:

    $ bundle exec rspec

or

    $ bundle exec rake spec

We've also included `pry` for you to drop in if you want to debug the code while you're running the specs.
