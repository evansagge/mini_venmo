module MiniVenmo
  class Commands
    class Feed
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def run
        # TODO: display a feed of the respective user's payments
      end

      private

      def user
        @user ||= MiniVenmo::Store.users[name]
      end
    end
  end
end
