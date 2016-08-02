module MiniVenmo
  class Commands
    class User
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def run
        validate!
        MiniVenmo::Store.users[name] = MiniVenmo::Models::User.new(name)
      end

      private

      def validate!
        raise Error.new('invalid argument') unless name =~ /^[\w\d\-]+$/
        raise Error.new('invalid argument') unless (4..15).cover?(name.length)
      end
    end
  end
end
