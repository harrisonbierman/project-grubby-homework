extends Node

var network: NetworkServer
var game: GameServer

var player_ids: Dictionary[int, int] = {}
var client_ids: Dictionary[int, int] = {}
var next_id: int = 0

func _ready() -> void:
	print("STARTED: ", get_tree().current_scene.scene_file_path)
	
	
	network = NetworkServer.new()
	game = GameServer.new()
	
	# connect network server signals 
	network.client_connected.connect(_on_client_connected)
	network.client_disconnected.connect(_on_client_disconnected)
	network.message_received.connect(_resolve_player_id_and_route)
	
	# connect game server signals
	game.message_outgoing.connect(_resolve_client_id_and_send)
	
	network.start()


func _resolve_client_id_and_send(player_id: int, message: Dictionary) -> void:
	if not client_ids.has(player_id):
		push_error("Server: could not resolve player id: ", player_id)
		return
	# resolve client_id
	var client_id: int = client_ids.get(player_id)
	network.send_message(client_id, message)

func _resolve_player_id_and_route(client_id: int, message: Dictionary) -> void:
	if not player_ids.has(client_id):
		push_error("Server: coulnd resolve client_id: ", client_id)
		return
	var player_id: int = player_ids.get(client_id)
	game.on_message_recieved(player_id, message)

func _on_client_connected(client_id: int) -> void:
	if not player_ids.has(client_id):
		print("Sever: client id: ", client_id, " has connected")
		player_ids.set(client_id, next_id)
		client_ids.set(next_id, client_id)
		next_id += 1
	
	
func _on_client_disconnected(client_id: int) -> void:
	var player_id: int = player_ids.get(client_id)
	player_ids.erase(client_id)
	client_ids.erase(player_id)
	
	print("Sever: client id:", client_id," with player id:", player_id, " has disconnected")
	
func _process(_delta: float) -> void:
	network.poll()
	
func _finalize() -> void:
	network.stop()
