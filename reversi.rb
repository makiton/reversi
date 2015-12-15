class Reversi
  BLACK = -1
  WHITE = 1
  SIZE = 8

  def initialize
    @board = SIZE.times.map do
      SIZE.times.map { 0 }
    end
    @board[3][3] = @board[4][4] = BLACK
    @board[3][4] = @board[4][3] = WHITE

    @turn = BLACK
    @enemy = WHITE
    @finish = false
  end

  def run 
    loop do
      render
      put_stone(*wait_input)

      if @finish
        puts 'The game is over.'
        print 'won:'
        case @won
        when BLACK
          puts 'x'
        when WHITE
          puts 'o'
        end
      end
    end
  end

  def change_turn!
    swp = @turn
    @turn = @enemy
    @enemy = swp
  end

  def put_stone(x, y)
    vectors = [
      [-1, -1], [-1, 0], [-1, 1],
      [0, -1], [0, 1],
      [1, -1], [-1, 0], [1, 1]
    ]

    reversed = false
    vectors.each do |dx, dy|
      cx = x
      cy = y
      detect_my_stone = false
      loop do
        cx += dx
        cy += dy
        reverse_point << [cx, cy] if @board[cx][cy] == @enemy
        if @board[cx][cy] == @turn
          detect_my_stone = true 
          break
        end
        break if [cx < 0, cy < 0, cx >= SIZE, cy >= SIZE].any?
      end

      if detect_my_stone && reverse_point.present?
        reverse_point.each do |rx, ry|
          @board[rx][ry] = @turn
        end
        reversed = true
      end
    end

    if reversed
      change_turn!
    end
  end

  def render
    @board.each do |row|
      row.each do |cell|
        case cell
        when -1
          print 'x'
        when 0
          print ' '
        when 1
          print 'o'
        end
      end
      print "\n"
    end
  end

  def wait_input
    if @turn == BLACK
      print "x's turn [x y]: "
    else
      print "o's turn [x y]: "
    end
    input = gets

    if input == 'exit'
      finish!
      return
    end

    input.split(' ').map(&:to_i)
  end

  def finish!
    @finish = true
  end
end
