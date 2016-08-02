require 'spec_helper'

RSpec.describe MiniVenmo::Commands::Feed do
  let(:instance) { described_class.new(name) }

  let(:name) { 'Thomas' }

  before do
    MiniVenmo::Command.new('user Thomas').run
    MiniVenmo::Command.new('user Lisa').run
    MiniVenmo::Command.new('user Quincy').run
    MiniVenmo::Command.new('add Thomas 4111111111111111').run
    MiniVenmo::Command.new('add Quincy 5555555555554444').run
    MiniVenmo::Command.new('pay Thomas Lisa $10.25 burritos').run
    MiniVenmo::Command.new('pay Thomas Quincy $10.00 you\'re awesome').run
    MiniVenmo::Command.new('pay Quincy Thomas $2.00 a subway card').run
    MiniVenmo::Command.new('pay Quincy Thomas $14.50 a redbull vodka').run
  end

  describe '#run' do
    subject { instance.run }

    it 'displays a feed of the payments involving the user' do
      feed = <<-FEED
      -- You paid Lisa $10.25 for burritos
      -- You paid Quincy $10.00 for you're awesome
      -- Quincy paid you $2.00 for a subway card
      -- Quincy paid you $14.50 for a redbull vodka
      FEED
      feed.gsub!(/^#{feed.scan(/^[ \t]*(?=\S)/).min}/, '') # strip_heredoc
      expect { subject }.to output(feed).to_stdout
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
