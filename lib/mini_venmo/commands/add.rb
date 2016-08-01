require 'mini_venmo/models/user'

module MiniVenmo
  class Commands
    class Add
      attr_reader :name, :card_number

      def initialize(name, card_number)
        @name = name
        @card_number = card_number
      end

      def run
        user.credit_card = CreditCard.new(card_number)
      end

      private

      def user
        @user ||= MiniVenmo::Models::User.find(name)
      end
    end
  end
end
