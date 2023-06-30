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

      it 'is has 6 elements' do
        length = board.length
        expect(length).to eq(6)
      end

      it 'all elements are of type Array' do
        result = board.all? do |element|
          element.is_a?(Array)
        end
        expect(result).to be true
      end

      it 'all elements has 7 elements of their own' do
        result = board.all? do |element|
          element.length == 7
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

    context 'when initializing @current_player' do
      subject(:player_one) { gameboard.instance_variable_get(:@player_one) }
      subject(:current_player) { gameboard.instance_variable_get(:@current_player) }

      it 'is equivalent to @player_one' do
        expect(current_player).to be(player_one)
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
        allow(gameboard).to receive(:gets).and_return(letter, two_digit, wrong_number, symbol, wrong_number_second,
                                                      valid)
      end

      it 'asks the player for a column number 6 times' do
        expect(gameboard).to receive(:gets).exactly(6).times
        gameboard.prompt_player(player_one)
      end
    end
  end

  describe '#place_chip' do
    subject(:tiles) { gameboard.instance_variable_get(:@board) }

    context 'when placing chip' do
      it 'places the chip on the board' do
        column = 5
        player = gameboard.instance_variable_get(:@player_one)
        expect { gameboard.place_chip(player, column) }.to change { tiles[0][5] }.to(player.chip)
      end

      it 'places the chip on the next row if a chip is present' do
        column = 5
        player = gameboard.instance_variable_get(:@player_one)
        gameboard.place_chip(player, column)
        expect { gameboard.place_chip(player, column) }.to change { tiles[1][5] }.to(player.chip)
      end

      it 'returns nil if chip was not placed' do
        column = 5
        player = gameboard.instance_variable_get(:@player_one)
        total_rows = tiles.length
        total_rows.times { gameboard.place_chip(player, column) }
        result = gameboard.place_chip(player, column)
        expect(result).to be_nil
      end
    end
  end

  describe '#switch_current_player' do
    subject(:player_one) { gameboard.instance_variable_get(:@player_one) }
    subject(:player_two) { gameboard.instance_variable_get(:@player_two) }

    it 'switches @current_player' do
      expect { gameboard.switch_current_player }.to change {
                                                      gameboard.instance_variable_get(:@current_player)
                                                    }.from(player_one).to(player_two)
    end
  end

  describe '#check_rows_for_winner' do
    subject(:tiles) { gameboard.instance_variable_get(:@board) }
    subject(:current_player) { gameboard.instance_variable_get(:@current_player) }

    context 'when all rows is not populated' do
      it 'returns false' do
        result = gameboard.check_rows_for_winner
        expect(result).to be(false)
      end
    end

    context 'when any row is populated' do
      context 'when any 4-line in a row contains blank' do
        it 'returns false' do
          result = gameboard.check_rows_for_winner
          expect(result).to be(false)
        end
      end

      context 'when any 4-line in a row contains chip belonging only to a single player' do
        before do
          4.times { |column| gameboard.place_chip(current_player, column) }
        end

        it 'returns true' do
          result = gameboard.check_rows_for_winner
          expect(result).to be(true)
        end
      end

      context 'when any 4-line in a row contains chip belonging to both players' do
        before do
          4.times do |column|
            gameboard.place_chip(gameboard.instance_variable_get(:@current_player), column)
            gameboard.switch_current_player
          end
        end

        it 'returns false' do
          result = gameboard.check_rows_for_winner
          expect(result).to be(false)
        end
      end
    end
  end

  describe '#check_columns_for_winner' do
    subject(:tiles) { gameboard.instance_variable_get(:@board) }
    subject(:current_player) { gameboard.instance_variable_get(:@current_player) }

    context 'when all columns is not populated' do
      it 'returns false' do
        result = gameboard.check_columns_for_winner
        expect(result).to be(false)
      end
    end

    context 'when any column is populated' do
      context 'when any 4-line in a column contains blank' do
        it 'returns false' do
          result = gameboard.check_columns_for_winner
          expect(result).to be(false)
        end
      end

      context 'when any 4-line in a column contains chip belonging only to a single player' do
        before do
          4.times { |_column| gameboard.place_chip(current_player, 0) }
        end

        it 'returns true' do
          result = gameboard.check_columns_for_winner
          expect(result).to be(true)
        end
      end

      context 'when any 4-line in a column contains chip belonging to both players' do
        before do
          4.times do |_column|
            gameboard.place_chip(gameboard.instance_variable_get(:@current_player), 0)
            gameboard.switch_current_player
          end
        end

        it 'returns false' do
          result = gameboard.check_rows_for_winner
          expect(result).to be(false)
        end
      end
    end
  end

  describe '#find_row_of_highest_chip' do
    subject(:tiles) { gameboard.instance_variable_get(:@board) }
    subject(:current_player) { gameboard.instance_variable_get(:@current_player) }

    context 'when passed in the column of last placed chip' do
      it 'returns the row number' do
        column = 0
        gameboard.place_chip(current_player, column)
        row_number = gameboard.find_row_of_highest_chip(column)
        expect(row_number).to eq(0)
      end

      it 'returns the row number' do
        column = 0
        gameboard.place_chip(current_player, column)
        gameboard.place_chip(current_player, column)
        row_number = gameboard.find_row_of_highest_chip(column)
        expect(row_number).to eq(1)
      end
    end

    context 'when column is not yet occupied' do
      it 'returns -1' do
        column = 0
        result = gameboard.find_row_of_highest_chip(column)
        expect(result).to eq(-1)
      end
    end

    context 'when chip is floating in mid-air' do
      it 'returns the row number' do
        column = 4
        row = 4
        tiles[row][column] = current_player.chip
        row_number = gameboard.find_row_of_highest_chip(column)
        expect(row_number).to eq(4)
      end
    end
  end
end
