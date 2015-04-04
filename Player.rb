# == Player
#
# This class represents a TicTacToe player.
# It stores a player's name and icon.
class Player
	attr_reader :name, :icon

	def initialize(name, icon)
		@name = name
		@icon = icon
	end
end
