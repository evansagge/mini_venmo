require 'luhn'

module MiniVenmo
  class Commands
    class Add
      attr_reader :name, :card_number

      def initialize(name, card_number)
        @name = name
        @card_number = card_number
      end

      def run
        validate!
        new_credit_card = MiniVenmo::Models::CreditCard.new(card_number, user)
        MiniVenmo::Store.credit_cards[card_number] = new_credit_card
        user.credit_card = new_credit_card
      end

      private

      def user
        @user ||= MiniVenmo::Store.users[name]
      end

      def validate!
        raise Error.new('invalid argument') if user.nil?
        raise Error.new('this user already has a valid credit card') if user_has_valid_credit_card?
        raise Error.new('that card has already been added by another user, reported for fraud!') if card_added_by_another_user?
        raise Error.new('this card is invalid') if invalid_card?
      end

      def user_has_valid_credit_card?
        !user.credit_card.nil?
      end

      def card_added_by_another_user?
        !MiniVenmo::Store.credit_cards[card_number].nil?
      end

      def invalid_card?
        !Luhn.valid?(card_number)
      end
    end
  end
end
