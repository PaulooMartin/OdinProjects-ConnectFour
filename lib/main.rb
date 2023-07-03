class GameBoard
  def initialize
    @board = Array.new(6) { Array.new(7, '-') }
    @player_one = Player.new('Player one', "\u26F4")
    @player_two = Player.new('Player two', "\u26DF")
    @current_player = @player_one
  end

  def prompt_player(player)
    prompt_message = "#{player.name}'s turn. Choose a column number to place your chip #{player.chip}  -> "
    column_number = ''
    until column_number.match?(/\A[0-5]\z/)
      print prompt_message
      column_number = gets.chomp
    end
    column_number.to_i
  end

  def place_chip(player, column)
    placed = nil
    @board.each do |row|
      next unless row[column] == '-'

      row[column] = player.chip
      placed = true
      break
    end
    placed
  end

  def switch_current_player
    @current_player = @current_player == @player_one ? @player_two : @player_one
  end

  def check_rows_for_winner
    chip = @current_player.chip
    @board.any? do |row|
      case row
      in [*, ^chip, ^chip, ^chip, ^chip, *]
        true
      else
        false
      end
    end
  end

  def check_columns_for_winner
    chip = @current_player.chip
    result = false
    @board.each_with_index do |row, r_index|
      next if r_index < 3
      row.each_with_index do |column_chip, c_index|
        four_line = [column_chip, @board[r_index-1][c_index], @board[r_index-2][c_index], @board[r_index-3][c_index]]
        result = four_line.all? { |sample| sample.include?(chip)}
        break if result
      end
      break if result
    end
    result
  end

  def find_row_of_highest_chip(column)
    row_number = 5
    current_tile_chip = @board[row_number][column]
    until !current_tile_chip.include?('-') || row_number < 0
      row_number -= 1
      current_tile_chip = @board[row_number][column]
    end
    row_number
  end

  def calculate_similar_upper_right(row, column)
    reference_chip = @board[row][column]
    count = 0
    upper_right = get_upper_right_chip(row + count, column + count)
    while upper_right == reference_chip
      count += 1
      upper_right = get_upper_right_chip(row + count, column + count)
    end
    count
  end

  def calculate_similar_lower_left(row, column)
    reference_chip = @board[row][column]
    count = 0
    lower_left = get_lower_left_chip(row - count, column - count)
    while lower_left == reference_chip
      count += 1
      lower_left = get_lower_left_chip(row - count, column - count)
    end
    count
  end

  def calculate_similar_upper_left(row, column)
    reference_chip = @board[row][column]
    count = 0
    upper_left = get_upper_left_chip(row + count, column - count)
    while upper_left == reference_chip
      count += 1
      upper_left = get_upper_left_chip(row + count, column - count)
    end
    count
  end

  def calculate_similar_lower_right(row, column)
    reference_chip = @board[row][column]
    count = 0
    upper_left = get_lower_right_chip(row - count, column + count)
    while upper_left == reference_chip
      count += 1
      upper_left = get_lower_right_chip(row - count, column + count)
    end
    count
  end

  private

  def get_upper_right_chip(row, column)
    upper_right_row = row + 1
    upper_right_column = column + 1
    return '-' if upper_right_row > 5 || upper_right_column > 6

    @board[upper_right_row][upper_right_column]
  end

  def get_lower_left_chip(row, column)
    lower_left_row = row - 1
    lower_left_column = column - 1
    return '-' if lower_left_row.negative? || lower_left_column.negative?

    @board[lower_left_row][lower_left_column]
  end

  def get_upper_left_chip(row, column)
    upper_left_row = row + 1
    upper_left_column = column - 1
    return '-' if upper_left_row > 5 || upper_left_column.negative?

    @board[upper_left_row][upper_left_column]
  end

  def get_lower_right_chip(row, column)
    lower_right_row = row - 1
    lower_right_column = column + 1
    return '-' if lower_right_row.negative? || lower_right_column > 6

    @board[lower_right_row][lower_right_column]
  end
end

class Player
  attr_reader :name, :chip

  def initialize(name, chip)
    @name = name
    @chip = chip
  end
end
