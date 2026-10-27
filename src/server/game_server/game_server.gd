class_name GameServer
extends RefCounted

signal message_outgoing(player_id: int, message: Dictionary)

var state: GameState

var command_processor := CommandProcessor.new(state)
var message_router := MessageRouter.new()

func _init() -> void:
	command_processor.command_rejected.connect(_on_command_rejected)
	
	message_router.register("command", command_processor)
	
func on_message_recieved(player_id: int, message: Dictionary) -> void:
	message_router.route(player_id, message)

func _on_command_rejected(result: CommandResult) -> void:
	var message: Dictionary = {
		"type": "command_result",
		"body": {
			"success": result.success,
			"code": result.code,
			"message": result.message
		}
	}
	
	message_outgoing.emit(result.player_id, message)
