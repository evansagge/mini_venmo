module MiniVenmo
  module Models
    Payment = Struct.new(:actor, :target, :amount, :note) do
      class << self
        attr_accessor :records
      end

      self.records = {}

      def initialize(*)
        super
        self.balance = 0.00
        self.payments = []
      end
    end
  end
end
