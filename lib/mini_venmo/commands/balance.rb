module MiniVenmo
  class Commands
    class Balance
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def run
        puts "-- #{format('$%.2f', user.balance)}"
      end

      private

      def user
        @user ||= MiniVenmo::Store.users[name]
      end
    end
  end
end
