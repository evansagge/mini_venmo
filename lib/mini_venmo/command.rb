require 'active_support/core_ext/string/inflections'
require 'mini_venmo/errors'
require 'mini_venmo/commands/user'
require 'mini_venmo/commands/add'
require 'mini_venmo/commands/pay'
require 'mini_venmo/commands/feed'
require 'mini_venmo/commands/balance'

module MiniVenmo
  class Command
    attr_reader :input

    def self.run(input)
      new(input.strip).run
    end

    def initialize(input)
      @input = input
    end

    def run
      command_name, *args = input.split(/\s/).map(&:strip)

      command = command_for(command_name, *args)
      command.run
    rescue Errors::Error => error
      puts "ERROR: #{error.message}"
    end

    def command_for(command_name, *args)
      command_class(command_name).new(*args)
    rescue ArgumentError
      raise Errors::InvalidArgumentError.new
    end

    def command_class(command_name)
      MiniVenmo::Commands.const_get(command_name.classify, true)
    rescue NameError
      raise Errors::CommandNotRecognizedError.new
    end
  end
end
