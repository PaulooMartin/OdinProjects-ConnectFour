require 'main'

describe Player do
  subject(:sample_player) { described_class.new('Player', 'X') }

  describe '#initialize' do
    it 'receives name argument and sets @name' do
      name = sample_player.name
      expect(name).to be_a String
    end

    it 'receives chip argument and sets @chip' do
      chip = sample_player.chip
      expect(chip).to be_a String
    end
  end
end