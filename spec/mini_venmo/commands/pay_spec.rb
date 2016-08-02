require 'spec_helper'

RSpec.describe MiniVenmo::Commands::Pay do
  let(:instance) { described_class.new(actor_name, target_name, amount, note) }

  let(:actor_name) { 'Thomas' }
  let(:target_name) { 'Lisa' }
  let(:amount) { '$10.25' }
  let(:note) { 'burritos' }

  before do
    MiniVenmo::Command.new('user Thomas').run
    MiniVenmo::Command.new('add Thomas 4111111111111111').run
    MiniVenmo::Command.new('user Lisa').run
    MiniVenmo::Command.new('add Lisa 5454545454545454').run
  end

  describe '#run' do
    let(:user) { MiniVenmo::Models::User.new('Thomas') }
    let(:payment) { MiniVenmo::Models::Payment.new(MiniVenmo::Store.users[actor_name], MiniVenmo::Store.users[target_name], amount, note) }

    subject { instance.run }

    it "adds a new Payment to the actor's feed" do
      expect { subject }.to change { MiniVenmo::Store.users[actor_name].payments }.from([]).to([payment])
    end

    it "adds a new Payment to the target's feed" do
      expect { subject }.to change { MiniVenmo::Store.users[target_name].payments }.from([]).to([payment])
    end

    it "increases the target's balance" do
      expect { subject }.to change { MiniVenmo::Store.users[target_name].balance }.from(0.00).to(10.25)
    end

    it "does not decrease the actor's balance (credit card is charged instead)" do
      expect { subject }.not_to change { MiniVenmo::Store.users[actor_name].balance }
    end

    context 'validations' do
      context 'if user with actor_name does not exist' do
        let(:actor_name) { 'Quincy' }

        specify do
          expect { subject }.to raise_error(MiniVenmo::Error, 'invalid arguments')
        end
      end

      context 'if user with target_name does not exist' do
        let(:target_name) { 'Quincy' }

        specify do
          expect { subject }.to raise_error(MiniVenmo::Error, 'invalid arguments')
        end
      end

      context 'if amount is not in the dollar format ($1.25)' do
        let(:amount) { '1.25' }

        specify do
          expect { subject }.to raise_error(MiniVenmo::Error, 'invalid arguments')
        end
      end

      context 'if actor_name is the same as target_name' do
        let(:target_name) { actor_name }

        specify do
          expect { subject }.to raise_error(MiniVenmo::Error, 'users cannot pay themselves')
        end
      end

      context 'if user with actor_name has no credit card' do
        before do
          MiniVenmo::Store.users[actor_name].credit_card = nil
        end

        specify do
          expect { subject }.to raise_error(MiniVenmo::Error, 'this user does not have a credit card')
        end
      end
    end
  end
end
