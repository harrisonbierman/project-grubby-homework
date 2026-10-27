class_name NetworkClient
extends RefCounted

var PORT := 8910;
var SERVER_IP := "127.0.0.1"

var peer := ENetMultiplayerPeer.new()

signal message_received(message: Dictionary)

# Called when the node enters the scene tree for the first time.
func start() -> void:
	var error: Error = peer.create_client(SERVER_IP, PORT)
	
	if error != OK:
		push_error("Failed to create client")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func poll() -> void:
	peer.poll()
	
	while peer.get_available_packet_count() > 0:
		var packet: PackedByteArray = peer.get_packet()
		
		var message: Variant = JSON.parse_string(packet.get_string_from_utf8())
		if message == null:
			push_error("failed to parse string")
			
		if message is Dictionary:
			message_received.emit(message)
		else:
			push_error("Invalid message recieved")
			
func send_message(message: Dictionary) -> void:
	if peer.get_connection_status() != MultiplayerPeer.CONNECTION_CONNECTED:
		return
	else:
		var packet: PackedByteArray = JSON.stringify(message).to_utf8_buffer()
		peer.put_packet(packet)
			
			
		
		
