# MiniVenmo

This is the Venmo Challenge.

## Requirements

Ruby 2.3.1
Bundler 1.12.5

## Installation

1. Run `bin/setup` to do all the bundler installation
2. Run `bin/mini_venmo`

You can also choose to build the executable for this and install it in your executable path:

1. Run `bin/setup` to do all the bundler installation
2. Run `bundle exec rake build install`
3. If you are on `rbenv`, you may need to run `rbenv rehash`.
4. Run `mini_venmo`

## Usage

The program supports 2 modes of execution:
* interactively (from stdin), when run with no arguments
* from a file of newline-delimited commands, when provided with one argument

###Running interactively:

The following commands are supported:

* `user` will create a new user with a given name.
  * syntax: `user <user>`
  * User names should be alphanumeric but also allow underscores and dashes.
  * User names should be no shorter than 4 characters but no longer than 15.
  * Users start with a balance of $0.

* `add` will create a new credit card for a given name, card number
  * syntax: `add <user> <card_number>`
  * Card numbers should be validated using Luhn-10.
  * Cards that fail Luhn-10 will display an error message.
  * Cards that have already been added will display an error message.
  * Users can only have one card. Attempting to add a second valid card will display an error message.

* `pay` will create a payment between two users.
  * syntax: `pay <actor> <target> <amount> <note>`
  * `<actor>` and `<target>` are usernames that were created in #1
  * Users cannot pay themselves.
  * Payments will always charge the actor's credit card (not decrement their balance).
  * Payments will always increase the target's balance.
  * If the actor user has no credit card, an error message will be printed out.
  * Amount will be prefixed with "$" and will be dollars and cents

* `feed` will display a feed of the respective user's payments.
  * syntax: `feed <user>`

* `balance` will display a user's balance
  * syntax: `balance <user>`

* `exit` will close the program

### Running with a file path as an arguments

Run `mini_venmo <path_to_file>` to load a file that contains any of the commands above. Each line in the file will be processed
sequentially

## Testing

Run `bundle exec rspec` to run the unit tests.

Run `bundle exec cucumber` to run the feature/integration tests.

Each of these test suites will output code coverage in `coverage/index.html`

## Design Decisions

1. Language choice: Ruby

  Based on the requirements of the project, I made the conscious decision to use Ruby for two major reasons:

  - It is one of, if not the topmost, languages with which I have a large degree of expertise.
    This makes writing the code faster and a more efficient use of my time.
  - It allows me to leverage several years of experience writing clean and efficient Ruby code to show off
    my skills for this project.
  - It has an excellent community support especially with RubyGems, so I have all the libraries I need to
    write the solution to this project faster.
  - The bulk of the code involves text processing, and Ruby excels at that being a language evolve from
    other text-processing languages such as Perl, Smalltalk, and Lisp.
  - There is no obvious need for multithreading or other requirements for improving processing speed for this project,
    and that is usually only when I would feel the need to go with other languages that support these features
    better like Java or Go.

2. Framework: Methadone

  I believe in not reinventing wheels, and if there are wheels that would allow me build the vehicle faster, I prefer
  to take advantage of them. To this effect, I have used this gem called Methadone in previous projects before, and
  it does a pretty good job of simplifying and bootstraping command-line operations so that I can spend more time
  on working on implementation details rather than the boilerplate task such as writing parsers for command line options.

  On top of that, Methadone also comes fully-integrated with the Cucumber and Aruba gems, giving me the tools I need to
  work on a behavior-driven development approach with this project.

3. Separation of Concerns

  I believe projects are better when there's a proper separation between the application framework and the business logic.
  To this effect, I prefer to write service objects to encapsulate the business logic for this project, and invoke them from the framework.

  Each command (user, add, pay, feed, balance) is represented as service classes in MiniVemo::Commands, and each contain the raw
  actions that they represent. Validations are also included in these service classes (rather than in the models) as
  these are where they are invoked, thus making these service classes act as form classes as well.

  Models for User, CreditCard and Payment are basically Struct object to allow for specifying simple attribute accessors. Other than
  a few decorating methods, there's not a lot of logic here as they're there to represent state and not include behavior (behaviors are
  specified in the service classes).

  For data store, there's MiniVenmo::Store which includes Hash objects for created Users and CreditCards, so they're stored in memory.
  This means that state will not be persisted after exiting the application. The use of Hash objects was a good decision as it gives
  us simple lookup tables that we can use to find a User with a given name or a CreditCard with a given number.

  Note that there's no storage needed for Payment objects, as we don't do lookups from the top-level namespace. Rather, we associate
  Payment objects to their respective actor and target User objects so we can easily fetch them from the Feed command.

  The use of a base MiniVenmo::Error class is excellent for distinguishing between exceptions caused by business logic errors and
  framework/syntax errors. We throw MiniVenmo::Error from the MiniVenmo::Commands classes, and let the MiniVenmo::Command handle
  them, in this case printing them to the STDOUT. We also let MiniVenmo::Command print the result of MiniVenmo::Commands into STDOUT
  if the result is not nil, thus centralizing all STDOUT streams in MiniVenmo::Command.

4. Testing

  To clearly understand the code and to maintain good quality, both unit and integration test would be good to have.
  Using RSpec for unit tests and Cucumber for integration tests would be necessary for this.

  To make the process easier, integration tests are written first and made to pass as I write the implementation. Unit tests are fleshed
  out as the interface for the classes are written.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
