extends Node2D
class_name Mover

# Node2D already has access to position
var velocity: Vector2 = Vector2(0,0)
var camera: Camera2D
var acc: Vector2
var max_speed: float = 5.0

var colors: Array = [
	"Red", 
	"Green", 
	"Blue", 
	"Yellow", 
	"Orange", 
	"Purple", 
	"Pink",
	"Black"
]
var col: Color
func _ready():
	col = Color(colors.pick_random())

func set_acceleration(new_acc: Vector2) -> void:
	acc = new_acc
	
func set_velocity(vel: Vector2) -> void:
	velocity = vel

func set_camera(cam: Camera2D) -> void:
	camera = cam

func _draw():
	draw_circle(position,30, col,true)

func _process(_delta):
	check_position()
	add_acceleration()
	global_position += velocity # Godot allows for addition of two vector2 (1,2) + (1,5) = (2,7)
	queue_redraw()

func check_position() -> void:
	if global_position.y < 0:
		global_position.y = camera.get_viewport_rect().size.y/2
	elif global_position.y > camera.get_viewport_rect().size.y/2:
		global_position.y = 0
	elif global_position.x < 0:
		global_position.x = camera.get_viewport_rect().size.x/2
	elif global_position.x > camera.get_viewport_rect().size.x/2:
		global_position.x = 0

func add_acceleration() -> void:
	if abs(velocity.x) < max_speed or abs(velocity.y) < max_speed:
		velocity += acc/10
	
