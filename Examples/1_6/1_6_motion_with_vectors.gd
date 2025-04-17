extends Node2D
var mover_obj: Mover
@onready var camera_2d = $Camera2D

func _ready():
	for i in range(10):
		add_moving_object()

func _process(delta):
	pass

func add_moving_object() -> void:
	mover_obj = Mover.new()
	add_child(mover_obj)
	mover_obj.global_position = camera_2d.get_screen_center_position()/2
	mover_obj.set_camera(camera_2d)
	mover_obj.set_acceleration(Vector2(randf_range(-1,1),randf_range(-1,1)))
