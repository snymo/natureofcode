extends Node2D
@onready var camera_2d = $Camera2D
var top_left_position: Vector2
var margin_pos: Vector2
var vector_magnitude: float

func _ready():
	top_left_position = camera_2d.get_screen_center_position() - camera_2d.get_viewport_rect().size/2
	margin_pos = Vector2(top_left_position.x + 120, top_left_position.y + 30)
	
func _draw():
	#draw_circle(margin_pos,10, Color("Red"),true)
	draw_line(camera_2d.global_position, get_global_mouse_position(), Color("Red"), 10, true)
	draw_line(margin_pos, Vector2(margin_pos.x+vector_magnitude, margin_pos.y), Color("Gray"), 10, true )
	
func _process(_delta):
	vector_magnitude = calculate_mag(camera_2d.global_position, get_global_mouse_position())
	#print("Magnitude: "+str(vector_magnitude))
	queue_redraw()

func calculate_mag(v1: Vector2, v2: Vector2) -> float:
	return sqrt(v2.x * v2.x + v2.y * v2.y)
