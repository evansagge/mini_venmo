module MiniVenmo
  module Models
    class User
      class << self
        attr_accessor :records

        def find(name)
          [*records].detect { |user| user.name == name }
        end

        def create(name)
          self.records ||= []
          records << new(name)
        end
      end

      attr_reader :name, :credit_card, :balance
      attr_writer :credit_card

      def initialize(name)
        @name = name
        @balance = 0.00
      end
    end
  end
end
