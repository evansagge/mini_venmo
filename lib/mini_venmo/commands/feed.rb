require 'mini_venmo/models/user'

module MiniVenmo
  class Commands
    class User
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def run
        # TODO: display a feed of the respective user's payments
      end

      private

      def user
        @user ||= MiniVenmo::Models::User.find(name)
      end
    end
  end
end
