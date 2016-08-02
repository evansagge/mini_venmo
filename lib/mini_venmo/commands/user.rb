module MiniVenmo
  class Commands
    class User
      VALID_NAME_FORMAT = /^[\w\d\-]+$/
      VALID_NAME_LENGTH_RANGE = 4..15

      attr_reader :name

      def initialize(name)
        @name = name
      end

      def run
        validate!
        MiniVenmo::Store.users[name] = MiniVenmo::Models::User.new(name)
        nil
      end

      private

      def validate!
        validate_name_format!
        validate_name_length!
      end

      def validate_name_format!
        raise Error.new('invalid arguments') unless name =~ VALID_NAME_FORMAT
      end

      def validate_name_length!
        raise Error.new('invalid arguments') unless VALID_NAME_LENGTH_RANGE.cover?(name.length)
      end
    end
  end
end
