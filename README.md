# Reverse Polish Notation Calculator

Demo is available at: [http://reverse-polish-notation.herokuapp.com](http://reverse-polish-notation.herokuapp.com)

Algorithm derived from: 
[http://en.wikipedia.org/wiki/Reverse_Polish_notation#Current_implementations](http://en.wikipedia.org/wiki/Reverse_Polish_notation#Current_implementations)

## Dependencies

This Rails 3.2.12 project uses HAML, RSpec, and Webrat, which means Nokogiri is required.

On Ubuntu / Debian systems, you may have to install some libraries for Nokogiri:

    sudo apt-get install libxslt1-dev libxml2-dev

No database is used whatsoever as it was unnecessary.

## Installation

    bundle install

## Running Tests

    rake

I neglected to write view tests and only wrote controller tests.

## Improvements

The following areas could be improved:

* Allow all valid Ruby operators by using Ruby metaprogramming instead of whitelisting approved operators
* GET parameter for /calculate could be AJAX'ed for a slicker user interface 
* Moving the calculator logic into a model or library for a slimmer controller and eschewing private controller method tests 
* Some front end tender love and care
* Trying my hand at a decimal compatible RPN?
