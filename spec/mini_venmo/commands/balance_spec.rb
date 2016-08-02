require 'spec_helper'

RSpec.describe MiniVenmo::Commands::Balance do
  let(:instance) { described_class.new(name) }

  let(:name) { 'Thomas' }

  before do
    MiniVenmo::Store.users['Thomas'] = MiniVenmo::Models::User.new('Thomas', nil, nil, 12.50)
  end

  describe '#run' do
    subject { instance.run }

    it 'displays a the balance for the given user name' do
      expect { subject }.to output("-- $12.50\n").to_stdout
    end

    context 'validations' do
      context 'if user with name does not exist' do
        let(:name) { 'Daisy' }

        specify do
          expect { subject }.to raise_error(MiniVenmo::Error, 'invalid arguments')
        end
      end
    end
  end
end
