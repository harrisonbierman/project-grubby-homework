extends Camera2D

@export var move_speed: float = 600.0
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.4
@export var max_zoom: float = 3.0


func _process(delta: float) -> void:
	var direction := Vector2.ZERO

	if Input.is_physical_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		direction.y -= 1
	if Input.is_physical_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		direction.y += 1
	if Input.is_physical_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction.x -= 1
	if Input.is_physical_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction.x += 1

	position += direction.normalized() * move_speed * delta / zoom.x


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			change_zoom(1.0 + zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			change_zoom(1.0 / (1.0 + zoom_speed))


func change_zoom(factor: float) -> void:
	var new_zoom := clampf(zoom.x * factor, min_zoom, max_zoom)
	zoom = Vector2.ONE * new_zoom
