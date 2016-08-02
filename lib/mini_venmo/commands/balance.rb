module MiniVenmo
  class Commands
    class Balance
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def run
        validate!
        "-- #{format('$%.2f', user.balance)}"
      end

      private

      def user
        @user ||= MiniVenmo::Store.users[name]
      end

      def validate!
        validate_user!
      end

      def validate_user!
        raise Error.new('invalid arguments') if user.nil?
      end
    end
  end
end
