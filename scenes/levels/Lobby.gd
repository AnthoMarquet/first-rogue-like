extends Node

# Variables
const PORT = 7000
const DEFAULT_SERVER_IP = "127.0.0.1"
const MAX_CONNECTIONS = 6

## Contains the player info for all the players with the keys being the unique IDs
var players = {}

## Contains the info for the player, is local only
## Modified before the connection is made
## Is passed to all the other peers to store in `players`
var playerInfo = {
	"NAME": "Player Name"
}

# Signals
signal player_connected(_peerID : int, _playerInfo : Dictionary)
signal player_disconnected(_peerID : int)
signal server_disconnected

var playersLoaded : int = 0
var lobbyFile : PackedScene = preload("res://scenes/levels/Lobby.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	## Connect multiplayer signals
	multiplayer.peer_connected.connect(_player_connected)
	multiplayer.peer_disconnected.connect(_player_disconnected)
	multiplayer.connected_to_server.connect(_server_connected)
	multiplayer.connection_failed.connect(_server_connection_failed)
	multiplayer.server_disconnected.connect(_server_disconnected)


## When player connects send all the playerInfo to everyone
func _player_connected() -> void:
	pass

## When player disconnects, send info to everyone and remove them
func _player_disconnected() -> void:
	pass

## Host connected
func _server_connected() -> void:
	pass

## Host connection failed
func _server_connection_failed() -> void:
	pass

## Remove all info from server when disconnected
func _server_disconnected() -> void:
	pass
