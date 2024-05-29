class TicTacToe
    class Player
      attr_reader :symbol
  
      def initialize(symbol)
        @symbol = symbol
      end
  
      def make_move(board)
        loop do
          puts player_prompt
          move = gets.chomp.upcase
          if valid_move?(move) && board.place_move(move, symbol)
            break
          else
            puts "Invalid move. Try again."
          end
        end
      end

      private

      def player_prompt
        "It's #{symbol}'s turn: "
      end
  
      def valid_move?(move)
        move.match?(/^[A-C][D-F]$/)
      end
    end
  
    class Board
      attr_reader :grid, :size
  
      def initialize(size)
        @size = size
        @grid = Array.new(size) { Array.new(size) }
      end
  
      def place_move(move, symbol)
        row, col = translate_move(move)
        if valid_move?(row, col)
          @grid[row][col] = symbol
          true
        else
          false
        end
      end
  
      def draw
        puts "\n  " + ('D'..('D'.ord + size - 1).chr).to_a.join(" ")
        grid.each_with_index do |row, index|
          puts ('A'..'Z').to_a[index] + " " + row.map { |val| make_blanks(val) }.join("|")
        end
        puts "\n"
      end
  
      def full?
        grid.all? { |row| row.none?(&:nil?) }
      end
  
      def game_won?
        return true if check_rows || check_columns || check_diagonals
        false
      end
  
      private
 
      def check_rows
        @grid.any? { |row| row.uniq.length == 1 && !row[0].nil? }
      end
    
      def check_columns
        @grid.transpose.any? { |col| col.uniq.length == 1 && !col[0].nil? }
      end
    
      def check_diagonals
        diagonal1 = (0...size).map { |i| @grid[i][i] }
        diagonal2 = (0...size).map { |i| @grid[i][size - i - 1] }
    
        [diagonal1, diagonal2].any? { |diag| diag.uniq.length == 1 && !diag[0].nil? }
      end

      def translate_move(move)
        [move[0].ord - 'A'.ord, move[1].ord - 'D'.ord]
      end
  
      def valid_move?(row, col)
        row.between?(0, size - 1) && col.between?(0, size - 1) && grid[row][col].nil?
      end
  
      def make_blanks(val)
        val.nil? ? "_" : val
      end
    end
  
    def initialize(board_size)
      @board = Board.new(board_size)
      @players = [Player.new("X"), Player.new("O")]
      @current_player = @players.first
    end
  
    def play
      puts "\nLet's Play Tic-Tac-Toe\n"
      @board.draw
  
      while true
        @current_player.make_move(@board)
        @board.draw
  
        if @board.game_won?
          puts "Congratulations. Player " + @current_player.symbol + " won!"
          return
        elsif @board.full?
          puts "It's a tie!"
          return
        end
  
        @current_player = (@current_player == @players.first) ? @players.last : @players.first
      end
    end
  end
  
  # เริ่มเกม
  TicTacToe.new(3).play
  