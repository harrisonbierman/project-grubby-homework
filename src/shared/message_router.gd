# routes incoming messages to the correct processor
class_name MessageRouter
extends RefCounted

var processors: Dictionary[String, MessageProcessor] = {}

func register(type: String, processor: MessageProcessor) -> void:
	processors.set(type, processor)

func route(player_id: int, message: Dictionary) -> void:
	
	# validate message type before processing
	var raw_type: Variant = message.get("type")
	
	if raw_type == null:
		push_error("Server: message type cannot be null")
		return
	
	if not raw_type is String:
		push_error("Server: message type must be String")
		return
	
	var type: String = raw_type
	
	
	# validate message body before processing
	var raw_body: Variant = message.get("body")
	
	if raw_body == null:
		push_error("Server: message body cannot be null")
		return
		
	if not raw_body is Dictionary:
		push_error("Body must be Dictionary")
		return
	
	var body: Dictionary = raw_body
	
	# validate message type with process registery
	if not processors.has(type):
		push_error("Server: Invalid processor type: {", type, "} consider registering it")
		return
		
	var processor: MessageProcessor = processors.get(type)
	processor.process(player_id, body)
	
	
