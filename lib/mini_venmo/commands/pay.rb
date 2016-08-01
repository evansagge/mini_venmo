require 'mini_venmo/models/user'

module MiniVenmo
  class Commands
    class Pay
      attr_reader :actor_name, :target_name, :amount, :note

      def initialize(actor_name, target_name, amount, note)
        @actor_name = actor_name
        @target_name = target_name
        @amount = amount
        @note = note
      end

      def run
        # TODO: create payment between two users
      end

      private

      def actor
        @actor ||= MiniVenmo::Models::User.find(actor_name)
      end

      def target
        @target ||= MiniVenmo::Models::User.find(target_name)
      end
    end
  end
end
