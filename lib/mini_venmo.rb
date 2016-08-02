require 'mini_venmo/version'
require 'mini_venmo/command'
require 'mini_venmo/models/credit_card'
require 'mini_venmo/models/payment'
require 'mini_venmo/models/user'
require 'highline'

module MiniVenmo
  def self.run_file(path)
    initialize_store
    File.foreach(path) do |line|
      puts "> #{line}"
      Command.run(line)
    end
  end

  def self.run_interactive
    initialize_store
    cli = HighLine.new
    loop do
      input = cli.ask '> '
      break if input.empty? || input == 'exit'
      Command.run(input)
    end
  end

  def self.initialize_store
    MiniVenmo::Models::User.records = {}
  end
end
