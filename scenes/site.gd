class_name Site
extends Area2D

signal clicked(site_id: int)

@export var site_id: int
@export var adjacent_sites: Array[Site] = []

@onready var piece_anchor: Marker2D = $PieceAnchor
@onready var highlight: Sprite2D = $Highlight


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	highlight.hide()

func _input_event(
	_viewport: Viewport,
	event: InputEvent,
	_shape_idx: int
) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit(site_id)	
			
func set_highlighted(value: bool) -> void:
	highlight.visible = value
	
func get_piece_position() -> Vector2:
	return piece_anchor.global_position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
	
