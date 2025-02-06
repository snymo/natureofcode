extends Camera2D

var speed = 400
var zoom_speed = 0.1
var min_zoom = 0.1
var max_zoom = 2.0

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		position.x += speed * delta
	if Input.is_action_pressed("ui_left"):
		position.x -= speed * delta
	if Input.is_action_pressed("ui_down"):
		position.y += speed * delta
	if Input.is_action_pressed("ui_up"):
		position.y -= speed * delta

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var mouse_pos = get_viewport().get_mouse_position()
			var old_zoom = zoom
			
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom = zoom.lerp(zoom * 1.1, zoom_speed)
			else:
				zoom = zoom.lerp(zoom * 0.9, zoom_speed)
			zoom = zoom.clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
			
			var viewport_size = get_viewport().get_visible_rect().size
			var offset = mouse_pos - (viewport_size / 2)
			var zoom_factor = Vector2.ONE / old_zoom - Vector2.ONE / zoom
			position += offset * zoom_factor
