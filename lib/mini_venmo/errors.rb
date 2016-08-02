module MiniVenmo
  module Errors
    class Error < StandardError; end

    class InvalidArgumentError < Error
      def message
        'invalid argument'
      end
    end

    class CommandNotRecognizedError < Error
      def message
        'command not recognized'
      end
    end
  end
end
