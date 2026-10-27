class_name CommandProcessor
extends MessageProcessor

signal command_rejected(command_result: CommandResult)

var state: GameState
var handlers: Dictionary = {
	"move_plan": MovePlanHandler.new()
}

# inject state as a depency
func _init(state: GameState) -> void:
	self.state = state

func process(
	player_id: int,
	body: Dictionary
	) -> void:
	
	# return variant for error handling
	var raw_type: Variant = body.get("command")
	
	if not raw_type is String:
		push_error("Command must be a string")
		return
		
	var type: String = raw_type

	var handler: CommandHandler = handlers.get(type)
	
	# command not recognized error send message back to client
	if handler == null:
		return
	
	var result: CommandResult = handler.validate(player_id, body, state)
	
	if not result.success: 
		command_rejected.emit(result)
	else: 
		handler.execute(player_id, body, state)
		return
		
		
	
	
		
	
