class GameBoard
  def initialize
    @board = Array.new(7) { Array.new(6, '-') }
    @player_one = Player.new('Player one', "\u26F4")
    @player_two = Player.new('Player two', "\u26DF")
  end
end

class Player
  attr_reader :name, :chip

  def initialize(name, chip)
    @name = name
    @chip = chip
  end
end
