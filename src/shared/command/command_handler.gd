@abstract
class_name CommandHandler
extends RefCounted

@abstract
func validate(player_id: int, body: Dictionary, state: GameState) -> CommandResult
	
@abstract
func execute(player_id: int, body: Dictionary, state: GameState) -> void
