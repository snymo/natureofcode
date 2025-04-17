extends Node2D
#Simple visualization of vector multiplication
@onready var camera_2d = $Camera2D

@onready var canvas_center: Vector2

var vector_multiply: float = 0.5 # Cut vector in half (multiply by 0.5)

func _ready():
	canvas_center = camera_2d.get_screen_center_position()

func _draw():
	draw_line(canvas_center, get_global_mouse_position(), Color("Gray"), 4, false)
	draw_line(canvas_center, get_global_mouse_position()*vector_multiply, Color("Red"),10, false)

func _process(delta):
	print(str(get_global_mouse_position())+" - "+str(get_global_mouse_position()*vector_multiply))
	queue_redraw()
