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

## Register new players informations
@rpc("any_peer", "reliable") ## Everyone calls it & makes sure the packet is received properly
func _register_player(_playerInfo : Dictionary) -> void:
	var newPlayerID : int = multiplayer.get_remote_sender_id()
	players[newPlayerID] = _playerInfo
	player_connected.emit(newPlayerID, _playerInfo)
	print("PLAYER REGISTERED: ", _playerInfo)

## When player connects send all the playerInfo to everyone
func _player_connected(_id: int) -> void:
	_register_player.rpc_id(_id, playerInfo)
	print("PLAYER CONNECTED: ", _id)

## When player disconnects, send info to everyone and remove them
func _player_disconnected(_id: int) -> void:
	players.erase(_id)
	player_disconnected.emit(_id)

## Host connected
func _server_connected() -> void:
	var peerID : int = multiplayer.get_unique_id()
	players[peerID] = playerInfo
	player_connected.emit(peerID, playerInfo)

## Host connection failed
func _server_connection_failed() -> void:
	multiplayer.multiplayer_peer = null
	printerr("SERVER CONNECTION FAILED")

## Remove all info from server when disconnected
func _server_disconnected() -> void:
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
