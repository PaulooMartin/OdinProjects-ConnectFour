class GameBoard
  def initialize
    @board = Array.new(7) { Array.new(6, '-') }
  end
end

class Player
  attr_reader :name, :chip

  def initialize(name, chip)
    @name = name
    @chip = chip
  end
end
