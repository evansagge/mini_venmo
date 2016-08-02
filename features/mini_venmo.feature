Feature: Mini-Venmo
  This program allows processing transactions like Venmo, given certain commands.

  Requirements:
  - the program supports two modes of execution:
    * interactively (from stdin), when run with no arguments
    * from a file of newline-delimited commands, when provided with one argument
  - the program accepts the ff. commands: "user", "add", "pay", "feed", and "balance"
    * these commands are accompanied with arguments specific to each command
    * each command may be processed from standard input, or as a line from an input file passed on execution of this program
    * any unsupported command will print an error
    * any input that does not fit the ff. specifications will print an error
    * commands:
      * "user" will create a new user with a given name.
        * e.g., `user <user>`
        * User names should be alphanumeric but also allow underscores and dashes.
        * User names should be no shorter than 4 characters but no longer than 15.
        * Users start with a balance of $0.
      * "add" will create a new credit card for a given name, card number
        * e.g., `add <user> <card_number>`
        * Card numbers should be validated using Luhn-10.
        * Cards that fail Luhn-10 will display an error.
        * Cards that have already been added will display an error.
        * Users can only have one card.
          Attempting to add a second valid card will display an error.
      * "pay" will create a payment between two users.
        * e.g., `pay <actor> <target> <amount> <note>`
        * `<actor>` and `<target>` are usernames that were created in #1
        * Users cannot pay themselves.
        * Payments will always charge the actor's credit card (not decrement their balance).
        * Payments will always increase the target's balance.
        * If the actor user has no credit card, display an error.
      * "feed" will display a feed of the respective user's payments.
        * e.g., `feed <user>`
      * "balance" will display a user's balance
        * e.g. `balance <user>`
  - input assumptions:
    * All input will be space delimited.
    * Credit card numbers may vary in length, up to 19 characters.
    * Credit card numbers will always be numeric.
    * Amounts will be prefixed with "$" and will be dollars and cents

  Scenario: The program is ran interactively
    When I run `mini_venmo` interactively
    And I type "user Thomas"
    And I type "user Lisa"
    And I type "user"
    And I type "foobar"
    When I type "user Quincy"
    And I type "add Thomas 4111111111111111"
    And I type "add Thomas 5454545454545454"
    When I type "add Lisa 5454545454545454"
    And I type "add Quincy 1234567890123456"
    When I type "pay Thomas Lisa $10.25 burritos"
    And I type "pay Thomas Quincy $10.00 you're awesome"
    And I type "pay Lisa Quincy $5.00 pot-luck supplies"
    And I type "pay Thomas Thomas $1.00 to myself"
    When I type "pay Quincy Thomas $2.00 a subway card"
    When I type "add Quincy 5454545454545454"
    And I type "add Quincy 5555555555554444"
    And I type "pay Quincy Thomas $14.50 a redbull vodka"
    And I type "feed Quincy"
    And I type "balance Quincy"
    And I type "feed Thomas"
    And I type "feed Lisa"
    Then I type "exit"
    Then the output should contain "ERROR: invalid arguments"
    Then the output should contain "ERROR: command not recognized"
    Then the output should contain "ERROR: this user already has a valid credit card"
    Then the output should contain "ERROR: this card is invalid"
    Then the output should contain "ERROR: users cannot pay themselves"
    Then the output should contain "ERROR: this user does not have a credit card"
    Then the output should contain "ERROR: that card has already been added by another user, reported for fraud!"
    Then the output should contain:
      """
      -- Thomas paid you $10.00 for you're awesome
      -- Lisa paid you $5.00 for pot-luck supplies
      -- You paid Thomas $14.50 for a redbull vodka
      """
    Then the output should contain:
      """
      -- $15.00
      """
    Then the output should contain:
      """
      -- You paid Lisa $10.25 for burritos
      -- You paid Quincy $10.00 for you're awesome
      -- Quincy paid you $14.50 for a redbull vodka
      """
    Then the output should contain:
      """
      -- Thomas paid you $10.25 for burritos
      -- You paid Quincy $5.00 for pot-luck supplies
      """

  Scenario: The program is ran with a path to a file as an argument
    Given a file named "transactions.txt" with:
      """
      user Thomas
      user Lisa
      user
      foobar
      user Quincy
      add Thomas 4111111111111111
      add Thomas 5454545454545454
      add Lisa 5454545454545454
      add Quincy 1234567890123456
      pay Thomas Lisa $10.25 burritos
      pay Thomas Quincy $10.00 you're awesome
      pay Lisa Quincy $5.00 pot-luck supplies
      pay Thomas Thomas $1.00 to myself
      pay Quincy Thomas $2.00 a subway card
      add Quincy 5454545454545454
      add Quincy 5555555555554444
      pay Quincy Thomas $14.50 a redbull vodka
      feed Quincy
      balance Quincy
      feed Thomas
      feed Lisa
      """
    When I successfully run `mini_venmo transactions.txt`
    Then the output should contain:
      """
      > user Thomas
      > user Lisa
      > user
      ERROR: invalid arguments
      > foobar
      ERROR: command not recognized
      > user Quincy
      > add Thomas 4111111111111111
      > add Thomas 5454545454545454
      ERROR: this user already has a valid credit card
      > add Lisa 5454545454545454
      > add Quincy 1234567890123456
      ERROR: this card is invalid
      > pay Thomas Lisa $10.25 burritos
      > pay Thomas Quincy $10.00 you're awesome
      > pay Lisa Quincy $5.00 pot-luck supplies
      > pay Thomas Thomas $1.00 to myself
      ERROR: users cannot pay themselves
      > pay Quincy Thomas $2.00 a subway card
      ERROR: this user does not have a credit card
      > add Quincy 5454545454545454
      ERROR: that card has already been added by another user, reported for fraud!
      > add Quincy 5555555555554444
      > pay Quincy Thomas $14.50 a redbull vodka
      > feed Quincy
      -- Thomas paid you $10.00 for you're awesome
      -- Lisa paid you $5.00 for pot-luck supplies
      -- You paid Thomas $14.50 for a redbull vodka
      > balance Quincy
      -- $15.00
      > feed Thomas
      -- You paid Lisa $10.25 for burritos
      -- You paid Quincy $10.00 for you're awesome
      -- Quincy paid you $14.50 for a redbull vodka
      > feed Lisa
      -- Thomas paid you $10.25 for burritos
      -- You paid Quincy $5.00 for pot-luck supplies
      """
