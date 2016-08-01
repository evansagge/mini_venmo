require 'mini_venmo/version'
require 'mini_venmo/command'
require 'highline'

module MiniVenmo
  def self.run_file(path)
    File.foreach(path) do |line|
      puts "> #{line}"
      Command.run(line)
    end
  end

  def self.run_interactive
    cli = HighLine.new
    loop do
      input = cli.ask '> '
      break if input.empty? || input == 'exit'
      Command.run(input)
    end
  end
end
