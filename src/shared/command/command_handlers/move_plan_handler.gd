class_name MovePlanHandler
extends CommandHandler

# dummy fail
var dummy_fail := CommandResult.new(
		0, 
		false, 
		"invalid_plan",
		"Cannot plan move because Sites are not adjacent"
		)

func validate(player_id: int, body: Dictionary, state: GameState) -> CommandResult:
	# dummy fail
	return dummy_fail

func execute(player_id: int, body: Dictionary, state: GameState) -> void:
	pass
