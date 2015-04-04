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
		dim_loop { |p|
			has_winner = true
			winner = proc.call(p * @dimension)
			1.upto(@dimension - 1) do |q|
				index = p * @dimension + q
				has_winner = false unless winner == proc.call(index)
			end
			return winner if has_winner && winner != nil
		}
		nil
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
		dim_loop { |p|
			has_winner = true
			winner = proc.call(p)
			1.upto(@dimension - 1) do |q|
				index = q * @dimension + p
				has_winner = false unless winner == proc.call(index)
			end
			return winner if has_winner && winner != nil
		}
		nil
	end

	# Loops through the diagionals of the board.
	#
	# ==== Arguments
	#
	# * +proc+ - To do at each space.
	#
	# ==== Returns
	#
	# * +Player+ - Returns nil, unless a player occupies an entire diagonal, then returns that player.
	def scan_diag(proc)
		has_winner = true
		winner = proc.call(0)
		1.upto(@dimension - 1) do |q|
			index = q * @dimension + q
			has_winner = false unless winner == proc.call(index)
		end
		return winner if has_winner && winner != nil

		has_winner = true
		winner = proc.call(6)
		@dimension - 2.downto(0) do |q|
			index = @dimension * (q + 1) - 1 - q
			has_winner = false unless winner == proc.call(index)
		end
		return winner if has_winner && winner != nil
		nil
	end

	# Loops from 0 to @dimension - 1 and yields to a given block within
	def dim_loop
		@dimension.times do |d|
			yield(d)
		end
	end
end
