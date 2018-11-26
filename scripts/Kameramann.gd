extends Node2D

var players = []

func _ready():
	pass

func _process(delta):
	if (players.size() == 1):
		position.x = players[0].position.x
		position.y = players[0].position.y
	elif (players.size() == 2):
		position.x = (players[0].position.x + players[1].position.x) / 2
		position.y = (players[0].position.y + players[1].position.y) / 2
	elif (players.size() == 3):
		position.x = (players[0].position.x + players[1].position.x + players[2].position.x) / 3
		position.y = (players[0].position.y + players[1].position.y + players[2].position.y) / 3
