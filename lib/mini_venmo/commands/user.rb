module MiniVenmo
  class Commands
    class User
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def run
        validate!
        MiniVenmo::Models::User.records[name] = MiniVenmo::Models::User.new(name)
      end

      private

      def validate!
        raise Errors::InvalidArgumentError unless name =~ /^[\w\d\-]+$/
        raise Errors::InvalidArgumentError unless (4..15).cover?(name.length)
      end
    end
  end
end
