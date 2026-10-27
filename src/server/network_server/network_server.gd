# Network server does not know anything about the game
# its only job is to listen for clients and send a signal
# when a message comes in and relay messages going out
# it does not understand the contents of the message
# It only knows the client ids of the clients connect

class_name NetworkServer
extends RefCounted

var peer := ENetMultiplayerPeer.new()

var PORT: int = 8910

signal message_received(peer_id: int, message: Dictionary)

signal client_connected(peer_id: int)
signal client_disconnected(peer_id: int)

func start() -> void:
	
	var error: Error = peer.create_server(8910)
	
	if error != OK:
		push_error("Failed to start server")
	
	print("Server: server created on port: ", PORT)
	
	# relay signals further up
	peer.peer_connected.connect(_on_peer_connected)
	peer.peer_disconnected.connect(_on_peer_disconnected)
	
func _on_peer_connected(id: int) -> void:
	client_connected.emit(id)

func _on_peer_disconnected(id: int) -> void:
	client_disconnected.emit(id)

func poll() -> void:
	peer.poll()
	
	while peer.get_available_packet_count() > 0:
		var sender_id: int = peer.get_packet_peer()
		var packet: PackedByteArray = peer.get_packet()
		
		var message: Dictionary = JSON.parse_string(
			packet.get_string_from_utf8()
		)
		
		if message is Dictionary:
			message_received.emit(sender_id, message)
		else:
			push_error("Invalid message received")
			
# SEND MESSAGE
func send_message(client_id: int, message: Dictionary) -> void:
	peer.set_target_peer(client_id)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED:
		var packet: PackedByteArray = JSON.stringify(message).to_utf8_buffer()
		peer.put_packet(packet)
	
func stop() -> void:
	peer.close()
	
