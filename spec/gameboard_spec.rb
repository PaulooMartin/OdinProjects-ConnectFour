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

  describe '#prompt_player' do
    subject(:player_one) { gameboard.instance_variable_get(:@player_one) }

    context 'when prompting player' do
      before do
        allow(gameboard).to receive(:print)
        allow(gameboard).to receive(:gets).and_return('4')
      end

      it 'sends the prompt message' do
        message = "#{player_one.name}'s turn. Choose a column number to place your chip #{player_one.chip}  -> "
        expect(gameboard).to receive(:print).with(message)
        gameboard.prompt_player(player_one)
      end

      it 'asks the player for a column number' do
        expect(gameboard).to receive(:gets)
        gameboard.prompt_player(player_one)
      end

      it 'returns a number' do
        result = gameboard.prompt_player(player_one)
        expect(result).to be_a(Numeric)
      end
    end

    context 'when player gives an invalid placement once then gives a valid one' do
      before do
        allow(gameboard).to receive(:print)
        allow(gameboard).to receive(:gets).and_return('%', '5')
      end

      it 'asks the player for a column number twice' do
        expect(gameboard).to receive(:gets).twice
        gameboard.prompt_player(player_one)
      end

      it 'sends the prompt message twice' do
        message = "#{player_one.name}'s turn. Choose a column number to place your chip #{player_one.chip}  -> "
        expect(gameboard).to receive(:print).with(message).twice
        gameboard.prompt_player(player_one)
      end
    end

    context 'when player gives an invalid placement 5 times then gives a valid one' do
      before do
        allow(gameboard).to receive(:print)
        letter = 'a'
        two_digit = '12'
        symbol = '$'
        wrong_number = '7'
        wrong_number_second = '9'
        valid = '5'
        allow(gameboard).to receive(:gets).and_return(letter, two_digit, wrong_number, symbol, wrong_number_second, valid)
      end

      it 'asks the player for a column number 6 times' do
        expect(gameboard).to receive(:gets).exactly(6).times
        gameboard.prompt_player(player_one)
      end
    end
  end
end
