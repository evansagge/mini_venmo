require 'mini_venmo/version'
require 'mini_venmo/command'
require 'mini_venmo/store'
require 'mini_venmo/models/credit_card'
require 'mini_venmo/models/payment'
require 'mini_venmo/models/user'
require 'highline'

module MiniVenmo
  def self.run_file(path)
    Store.initialize
    File.foreach(path) do |line|
      line.chomp!
      next if line.empty?
      puts "> #{line}"
      Command.run(line)
    end
  end

  def self.run_interactive
    Store.initialize
    cli = HighLine.new
    loop do
      input = cli.ask '> '
      input.chomp!
      break if input.empty? || input == 'exit'
      Command.run(input)
    end
  end
end
