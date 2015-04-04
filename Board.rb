# == Board
#
# This class represents the TicTacToe board.
# It's responsibilities are to keep track of the board's status,
# update it when moves are made and determine if a player has won.
class Board
	# == Initialization
	#
	# Initialize the TicTacToe board with standard dimension 3
	def initialize(dimension = 3)
		@dimension = dimension
		@board = []
		(dimension**2).times do
			@board.push(nil)
		end
	end

	# == Status
	#
	# This method prints the status of the board to the command line.
	def status
		dim_loop() { |p|
			print "\n"
		  dim_loop { |q|
				index = p * @dimension + q
				print @board[index] == nil ? "#{ index + 1 } " : "#{ @board[index].icon } "
			}
		}
		2.times { print "\n" }
	end

	# Execute a move on the board.
	#
	# ==== Arguments
	#
	# * +index+ - 0 <= index <= dimension**2
	# * +player+ - The player who is making the move
	#
	# ==== Returns
	#
	# * +Boolean+ - True if the move was succesfully executed, false if it is invalid.
	def move(index, player)
		empty(index - 1) ? set(index - 1, player) : false
	end

	# Finds a winner if there is one.
	#
	# ==== Returns
	#
	# * +Player+ - Returns the winning player or nil if there is no winner yet.
	def winner
		p1 = Proc.new { |index|  @board[index]}
		return scan_hor(p1) if scan_hor(p1)
		return scan_ver(p1) if scan_ver(p1)
		return scan_diag(p1) if scan_diag(p1)
	end

	private
	# Checks to see whether a space of the board is empty.
	#
	# ==== Arguments
	#
	# * +index+ - The index of the board space that will be checked.
	#
	# ==== Returns
	#
	# * +Boolean+ - False if the square at "index" is full, true otherwise.
	def empty(index)
		begin
			!@board[index] && 0 <= index && index < @dimension**2
		rescue
			false
		end
	end

	# Sets a space of the board to a value.
	#
	# ==== Arguments
	#
	# * +index+ - 0 <= index <= dimension**2
	# * +player+ - The player to whom to set the space's value
	def set(index, player)
		@board[index] = player
	end

	# Loops through the horizontal rows of the board.
	#
	# ==== Arguments
	#
	# * +proc+ - To do at each space.
	#
	# ==== Returns
	#
	# * +Player+ - Returns nil, unless a player occupies an entire row, then returns that player.
	def scan_hor(proc)
		left_to_right = Proc.new { |p| p * @dimension }
		scan_helper(proc, left_to_right) { |p, q| p * @dimension + q }
	end

	# Loops through the vertical columns of the board.
	#
	# ==== Arguments
	#
	# * +proc+ - To do at each space.
	#
	# ==== Returns
	#
	# * +Player+ - Returns nil, unless a player occupies an entire column, then returns that player.
	def scan_ver(proc)
		top_to_bottom = Proc.new { |p| p}
		scan_helper(proc, top_to_bottom) { |p, q| q * @dimension + p }
	end

	# Loops through the 2 diagionals of the board.
	#
	# ==== Arguments
	#
	# * +proc+ - To do at each space.
	#
	# ==== Returns
	#
	# * +Player+ - Returns nil, unless a player occupies an entire diagonal, then returns that player.
	def scan_diag(proc)
		top_left_to_bottom_right = Proc.new { |p| 0}
		result = scan_helper(proc, top_left_to_bottom_right) { |p, q| q * @dimension + q }
		return result if result

		bottom_left_to_top_right = Proc.new { |p| 6}
		res = scan_helper(proc, bottom_left_to_top_right) { |p, q| @dimension * (@dimension - q - 1) + q }
	end

	# Helper method for the scan methods.
	# Loops Through a rows, columns or a diagional and returns nil
	# unless a player occupies all spaces in said row, column or diagonal.
	#
	# ==== Arguments
	#
	# * +proc1+ - Calculation for first indexes of rows, columns or a diagonal.
	# * +proc2+ - Calculation for !first indexes of row, column or diagonal.
	#
	# ==== Returns
	#
	# * +Player+ - Returns nil, unless a player occupies an entire diagonal, then returns that player.
	def scan_helper(proc, proc2)
		dim_loop { |p|
			has_winner = true
			winner = proc.call(proc2.call(p))
			1.upto(@dimension - 1) do |q|
				index = yield(p, q)
				has_winner = false unless winner == proc.call(index)
			end
			return winner if has_winner && winner != nil
		}
		nil
	end

	# Loops from 0 to @dimension - 1 and yields to a given block
	def dim_loop
		@dimension.times do |d|
			yield(d)
		end
	end
end
