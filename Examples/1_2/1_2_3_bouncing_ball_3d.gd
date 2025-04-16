extends Node3D
# Simple bouncing ball - In 3D!

@onready var ball = $Ball
@onready var camera_3d = $Camera3D
const HIT_MARKER = preload("res://Examples/1_2/Marker/hit_marker.tscn")

var box_size: Vector3 = Vector3(20,20,20)
var ball_move_vector: Vector3 = Vector3(0.225,0.2,0.215)

func _process(delta):

	print(ball.global_position)
	ball.global_position += ball_move_vector
	
	if (ball.global_position.x > box_size.x) or (ball.global_position.x < 0):
		ball_move_vector.x *= -1
		add_marker(ball.global_position)
	if (ball.global_position.y > box_size.y) or (ball.global_position.y < 0):
		ball_move_vector.y *= -1
		add_marker(ball.global_position)
	if (ball.global_position.z > box_size.z) or (ball.global_position.z < 0):
		ball_move_vector.z *= -1
		add_marker(ball.global_position)

func add_marker(hit_pos: Vector3) -> void:
	var hit = HIT_MARKER.instantiate()
	add_child(hit)
	hit.global_position = hit_pos
	hit.visible = true
