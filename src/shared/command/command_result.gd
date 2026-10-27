class_name CommandResult
extends RefCounted

var player_id: int
var success: bool
var code: String
var message: String

func _init(
	_player_id: int,
	_success: bool, 
	_code: String = "", # default if not provided
	_message: String = "" # default
	) -> void:
	player_id = _player_id
	success = _success
	code = _code
	message = _message
