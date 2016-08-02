module MiniVenmo
  class Commands
    class Feed
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def run
        validate!
        user.payments.each do |payment|
          puts "-- #{compose_payment_message(payment)}"
        end
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

      def compose_payment_message(payment)
        message = [payment.amount, payment.note].reject(&:nil?).join(' for ')
        if payment.actor == user
          message.prepend("You paid #{payment.target_name} ")
        else
          message.prepend("#{payment.actor_name} paid you ")
        end
        message
      end
    end
  end
end
