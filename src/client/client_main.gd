extends Node

var network := NetworkClient.new()

@onready var button: Button = $Camera2D/UI/Button
@onready var disconnect_popup: PopupPanel = $Popups/DisconnectPopup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("STARTED: ", get_tree().current_scene.scene_file_path)
	
	network.start()
	
	network.message_received.connect(_on_message_received)
	network.server_disconnected.connect(_on_server_disconnected)
	button.button_down.connect(_on_button_pressed)

func _on_message_received(message: Dictionary) -> void:
	print("Client: message recieved: ", message)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	network.poll()

func _on_button_pressed() -> void:
	var msg: Dictionary = {
		"type": "command",
		"body": {
			"command": "move_plan"
			}
		}
	network.send_message(msg)

func _on_server_disconnected() -> void:
	disconnect_popup.popup_centered()
