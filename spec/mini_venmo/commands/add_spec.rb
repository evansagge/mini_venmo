require 'spec_helper'

RSpec.describe MiniVenmo::Commands::Add do
  let(:instance) { described_class.new(name, card_number) }

  let(:name) { 'Thomas' }
  let(:card_number) { '4111111111111111' }

  describe '#run' do
    let(:user) { MiniVenmo::Models::User.new('Thomas') }

    subject { instance.run }

    before do
      MiniVenmo::Store.users['Thomas'] = user
    end

    it 'adds a credit card with the given number to the user' do
      expect { subject }.to change { MiniVenmo::Store.users['Thomas'].credit_card }
        .from(nil).to(MiniVenmo::Models::CreditCard.new('4111111111111111', user))
    end

    context 'validations' do
      context 'if user with name does not exist' do
        let(:name) { 'Lisa' }

        specify do
          expect { subject }.to raise_error(MiniVenmo::Error, 'invalid argument')
        end
      end

      context 'if card number has non-numeric characters' do
        let(:card_number) { 'abcdefg1234567890123456' }

        specify do
          expect { subject }.to raise_error(MiniVenmo::Error, 'this card is invalid')
        end
      end

      context 'if card number fails to validate against Luhn-10' do
        let(:card_number) { '1234567890123456' }

        specify do
          expect { subject }.to raise_error(MiniVenmo::Error, 'this card is invalid')
        end
      end

      context 'if card number has already been added to another user' do
        before do
          MiniVenmo::Commands::User.new('Lisa').run
          MiniVenmo::Commands::Add.new('Lisa', card_number).run
        end

        specify do
          expect { subject }.to raise_error(MiniVenmo::Error, 'that card has already been added by another user, reported for fraud!')
        end
      end

      context 'if user already has a card' do
        before do
          MiniVenmo::Store.users['Thomas'].credit_card = MiniVenmo::Models::CreditCard.new('5454545454545454')
        end

        specify do
          expect { subject }.to raise_error(MiniVenmo::Error, 'this user already has a valid credit card')
        end
      end
    end
  end
end
