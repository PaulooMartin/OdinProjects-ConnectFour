require 'main'

# rubocop:disable Metrics/BlockLength
describe GameBoard do
  subject(:gameboard) { described_class.new }

  describe '#initialize' do
    context 'when initizalizing @board' do
      subject(:board) { gameboard.instance_variable_get(:@board) }

      it 'is an Array' do
        expect(board).to be_an Array
      end

      it 'is has 7 elements' do
        length = board.length
        expect(length).to eq(7)
      end

      it 'all elements are of type Array' do
        result = board.all? do |element|
          element.is_a?(Array)
        end
        expect(result).to be true
      end

      it 'all elements has 6 elements of their own' do
        result = board.all? do |element|
          element.length == 6
        end
        expect(result).to be true
      end
    end

    context 'when initializing @player_one' do
      subject(:player_one) { gameboard.instance_variable_get(:@player_one) }

      it 'belongs to Player class' do
        expect(player_one).to be_a(Player)
      end

      it 'has name' do
        name = player_one.name
        expect(name).to be_truthy
      end

      it 'has chip' do
        chip = player_one.chip
        expect(chip).to be_truthy
      end
    end

    context 'when initizalizing @player_two' do
      subject(:player_two) { gameboard.instance_variable_get(:@player_two) }

      it 'belongs to Player class' do
        expect(player_two).to be_a(Player)
      end

      it 'has name' do
        name = player_two.name
        expect(name).to be_truthy
      end

      it 'has chip' do
        chip = player_two.chip
        expect(chip).to be_truthy
      end
    end
  end
end
