module MiniVenmo
  module Models
    User = Struct.new(:name, :credit_card, :payments, :balance) do
      def initialize(*)
        super
        self.balance = 0.00
        self.payments = []
      end
    end
  end
end
