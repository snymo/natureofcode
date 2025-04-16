extends Node2D
## Bouncing ball
# The simplest version of a bouncing ball demo
@onready var ball = $Ball

var velocity_vector: Vector2 = Vector2(1,1)
var ball_move_speed = 10
var room_size: Vector2

func _ready():
	room_size = get_viewport_rect().size
	velocity_vector.x = ball_move_speed
	velocity_vector.y = ball_move_speed
func _process(delta):
	print(ball.global_position)
	ball.global_position += velocity_vector

	if (ball.global_position.x > room_size.x) or (ball.global_position.x < 0):
		velocity_vector.x *= -1
	if (ball.global_position.y > room_size.y) or (ball.global_position.y < 0):
		velocity_vector.y *= -1
