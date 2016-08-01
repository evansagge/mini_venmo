require 'mini_venmo/models/user'

module MiniVenmo
  class Commands
    class User
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def run
        MiniVenmo::Models::User.create(name)
      end
    end
  end
end
