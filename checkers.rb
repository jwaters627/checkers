# # encoding: utf-8


class String
  def black;          "\033[30m#{self}\033[0m" end
  def red;            "\033[31m#{self}\033[0m" end
  def green;          "\033[32m#{self}\033[0m" end
  def brown;          "\033[33m#{self}\033[0m" end
  def blue;           "\033[34m#{self}\033[0m" end
  def magenta;        "\033[35m#{self}\033[0m" end
  def cyan;           "\033[36m#{self}\033[0m" end
  def gray;           "\033[37m#{self}\033[0m" end
  def bg_black;       "\033[40m#{self}\033[0m" end
  def bg_red;         "\033[41m#{self}\033[0m" end
  def bg_green;       "\033[42m#{self}\033[0m" end
  def bg_brown;       "\033[43m#{self}\033[0m" end
  def bg_blue;        "\033[44m#{self}\033[0m" end
  def bg_magenta;     "\033[45m#{self}\033[0m" end
  def bg_cyan;        "\033[46m#{self}\033[0m" end
  def bg_gray;        "\033[47m#{self}\033[0m" end
  def bold;           "\033[1m#{self}\033[22m" end
  def reverse_color;  "\033[7m#{self}\033[27m" end
end




class Piece
  
  attr_reader :color
  attr_accessor :position
  
  UP_MOVES = [[-1, -1], [-1, 1]]
  DOWN_MOVES = [[1, -1], [1, 1]]
  UP_JUMPS = [[-2,-2], [-2, 2]]
  DOWN_JUMPS = [[2, -2], [2, 2]]
  
  def initialize(color, board, position)
    @color = color
    @board = board
    @position = position
    @king = false
  end
  
  def to_s
    if @color == :red
      "✪".red
    else
      "✪".black
    end
  end
  
  def become_king?
    if @color == :red && @position[0] == 7
      @king = true
    elsif @color == :black && @position[0] == 0
      @king = true
    end
  end

  def steps
    if @king
      UP_MOVES + DOWN_MOVES
    elsif @color == :red
      DOWN_MOVES
    else
      UP_MOVES
    end
  end
  
  def jumps
    if @king
      UP_JUMPS + DOWN_JUMPS
    elsif @color == :red
      DOWN_JUMPS
    else
      UP_JUMPS
    end
  end
  
  def moves(position)
    possible_moves = steps.map do |el|
      [position[0] + el[0], position[1] + el[1]]
    end
   possible_moves.select do |el| 
      (0...8).include?(el[0]) && (0...8).include?(el[1])
    end
  end
  
  def check_move(end_pos)
    moves(@position).include?(end_pos)
  end
  
  def dup(new_board)
    Piece.new(color, new_board, position, king)
  end

  def perform_slide(end_pos)
    @position = end_pos
  end

  def jump_moves(position)
    possible_moves = jumps.map do |el|
      [position[0] + el[0], position[1] + el[1]]
    end
    
    possible_moves.select do |el| 
      (0...8).include?(el[0]) && (0...8).include?(el[1])
    end
  end

  def find_jumped_piece(end_pos)
    direction = jump_moves(@position).index(end_pos)
    moves(@position)[direction]
  end

  def perform_jump(end_pos)
    if moves(@position).include?(end_pos)
      @position = end_pos
    else
      puts "You cannot jump there"
      false
    end
  end
end