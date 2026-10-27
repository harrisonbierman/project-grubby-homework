extends Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if "--server" in OS.get_cmdline_args():
		get_tree().change_scene_to_file.call_deferred("res://scenes/server_main.tscn")
	else:
		get_tree().change_scene_to_file.call_deferred("res://scenes/client.tscn")
