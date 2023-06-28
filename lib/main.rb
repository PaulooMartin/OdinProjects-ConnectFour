class GameBoard
  def initialize
    @board = Array.new(7) { Array.new(6, '-') }
    @player_one = Player.new('Player one', "\u26F4")
    @player_two = Player.new('Player two', "\u26DF")
    @current_player = @player_one
  end

  def prompt_player(player)
    prompt_message = "#{player.name}'s turn. Choose a column number to place your chip #{player.chip}  -> "
    column_number = ''
    until column_number.match?(/\A[0-6]\z/)
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
end

class Player
  attr_reader :name, :chip

  def initialize(name, chip)
    @name = name
    @chip = chip
  end
end
