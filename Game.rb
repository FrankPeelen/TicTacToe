# == Game
#
# This class represents a TicTacToe game.
# It itterates through one or more games of TicTacToe.
class Game
	require_relative 'board'
	require_relative 'player'

	def initialize
		play
	end

	private
	# Itterates through one or more games of TicTacToe
	def play
			player1 = Player.new(player_name(1), 'X')
			player2 = Player.new(player_name(2), 'O')
			board = Board.new
			until board.winner
				player_move(board, player1)
				break if board.winner
				player_move(board, player2)
			end
			puts "Congratulations, #{ board.winner.name }!! You have won!!"
			puts "The result is as follows:"
			board.status
	end

	private
	# Requests the user to input a player name.
	#
	# ==== Arguments
	#
	# * +num+ - The number of the player whom's name you want to ask.
	#
	# ==== Returns
	#
	# * +String+ - A string containing the name the user entered for Player #num.
	def player_name(num)
		puts "Please enter Player #{ num }'s name:"
		gets.chomp
	end

	def player_move(board, player)
		board.status
		puts "#{ player.name }, please enter the number of an empty space for your next move."
		loop do
			break if board.move(gets.chomp.to_i, player)
			board.status
			puts "#{ player.name }, that move is invalid. Please try again"
		end
	end
end
