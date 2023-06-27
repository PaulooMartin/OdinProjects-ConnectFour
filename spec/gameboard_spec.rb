require 'main'

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

      it 'all elements has 6 elements' do
        result = board.all? do |element|
          element.length == 6
        end
        expect(result).to be true
      end
    end
  end
end
