# # encoding: utf-8
require './checkers'


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


class Board
  attr_accessor :board
  def initialize
    @board = create_board
    @turn = :red
    make_move
  end
  
  def render
    @board.each_with_index do |row, row_index|
      render_string = ""
      row.each_with_index do |space, col_index|
        if space.is_a?(Piece) 
          render_string << " " + space.to_s + " " 
        elsif (row_index + col_index) % 2 != 0
          render_string << "   "
        else
          render_string << "   ".bg_cyan
        end
      end
      puts render_string
    end
  end
  
  def create_board
    board = Array.new(8) {Array.new(8) {nil}}

    [0, 1, 2, 5, 6, 7].each do |row|
      (0..7).each do |col|
        color = (row == 0 || row == 1 || row == 2 ? :red : :black)
        if (row + col).odd?
          board[row][col] = Piece.new(color, @board, [row, col])
        end
      end
    end
    board
  end
  
  def dup_board
    # BROKEN!!!!
    duped_board = Board.new
    @board.each_with_index do |row, row_index|
      row.each_with_index do |piece, col_index|
        if piece.nil?
          duped_board.board[row_index][col_index] = nil
        else
          duped_board.board[row_index][col_index] = Piece.new(piece.color, duped_board, piece.position.dup)
        end
      end
    end
    duped_board
  end
  
  def is_won?
    false
  end
  
  def get_move
    start_pos = []
    puts "Choose a spot"
    gets.chomp.split(",").each do |el|
      start_pos << el.to_i
    end
    start_pos
  end
  
  def make_move
    until is_won?
      system "clear"
      render
      puts "it is #{@turn}'s turn"
      start_pos = get_move
      end_pos = get_move
      piece = @board[start_pos[0]][start_pos[1]]
      make_move if piece.nil?
      if check_for_piece(end_pos)
        if (start_pos[0] - end_pos[0]).abs == 2
          check_for_jump(start_pos, end_pos)
        elsif piece.check_move(end_pos)
          add_piece(piece, end_pos)
          remove_piece(start_pos)
          @board[end_pos[0]][end_pos[1]].become_king?
          turn
        end
       end
    end
  end
  
  def check_for_piece(end_pos)
    if @board[end_pos[0]][end_pos[1]] != nil
      puts "There is already piece there!"
      return false
    end
    true
  end
  
  def remove_piece(pos)
    @board[pos[0]][pos[1]] = nil
  end
  
  def add_piece(piece, pos)
    piece.position = pos
    @board[pos[0]][pos[1]] = piece
  end
  
  def check_for_second_jump
    
    
  end
  
  def check_for_jump(start_pos, end_pos)
    piece = @board[start_pos[0]][start_pos[1]]
    middle_spot = piece.find_jumped_piece(end_pos)
    if @board[middle_spot[0]][middle_spot[1]].nil?
      puts "You cannot make this jump"
      return false
    end
    add_piece(@board[start_pos[0]][start_pos[1]], end_pos)
    remove_piece(start_pos)
    remove_piece(middle_spot)
    return true
  end

  def turn
    @turn = (@turn == :red ? :black : :red)
  end

end

b = Board.new

