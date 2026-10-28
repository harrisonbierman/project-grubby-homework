extends Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Launch arguments: ", OS.get_cmdline_args())
	if "--server" in OS.get_cmdline_args():
		get_tree().change_scene_to_file.call_deferred("uid://b8haqm7mlubwp") # server_main.tscn
		
		# dont use "--test" as launch option b/c its already an godot internal launch option
	elif "--run-test" in OS.get_cmdline_args():
		get_tree().change_scene_to_file.call_deferred("uid://bkolch1aclgwo") # run_all_tests.tscn
	else:
		get_tree().change_scene_to_file.call_deferred("uid://dmee4w0rgnv2g") # client_main.tscn
