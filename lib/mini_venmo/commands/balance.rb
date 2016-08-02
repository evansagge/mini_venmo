module MiniVenmo
  class Commands
    class Balance
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def run
        puts user.balance
      end

      private

      def user
        @user ||= MiniVenmo::Models::User.records[name]
      end
    end
  end
end
