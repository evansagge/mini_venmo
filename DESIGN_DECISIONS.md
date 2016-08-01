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
  To this effect, I prefer to write service objects to encapsulate the business logic for this project, and invoke them
  from the framework.

4. Testing

  To clearly understand the code and to maintain good quality, both unit and integration test would be good to have.
  Using Rspec for unit tests and Cucumber for integration tests would be necessary for this.


