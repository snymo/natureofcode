extends Node2D
class_name Walker

@onready var mesh_2d = $MeshInstance2D
@onready var line = $Line2D
@onready var rays = $Rays

var color_array = [
	Color.HOT_PINK,
	Color.DEEP_SKY_BLUE, 
	Color.SPRING_GREEN,
	Color.GOLD,
	Color.MEDIUM_PURPLE,
	Color.ORANGE_RED,
	Color.CYAN,
	Color.LIME,
	Color.MAGENTA,
	Color.TURQUOISE,
	Color.CORAL,
	Color.MEDIUM_ORCHID,
	Color.LAWN_GREEN,
	Color.DODGER_BLUE,
	Color.VIOLET,
	Color.TOMATO,
	Color.AQUAMARINE,
	Color.YELLOW_GREEN,
	Color.DEEP_PINK,
	Color.MEDIUM_TURQUOISE]

var walk_speed: float = 1.0
var draw_timer : Timer
var draw_delta : float = 0.1 # Draw ever .1 second

var line_timer: Timer
var line_lifetime_delta: float = 0.2 # Line points stay for .2 seconds.

var step_time: float = 0.0
var max_time := 0.1 # Wait time before a new step


# Called when the node enters the scene tree for the first time.
func _ready():
	draw_timer = Timer.new()
	add_child(draw_timer)
	draw_timer.timeout.connect(_on_draw_timer_timeout)
	draw_timer.start(draw_delta)
	
	line_timer = Timer.new()
	add_child(line_timer)
	line_timer.timeout.connect(_on_line_timer_timeout)
	line_timer.start(line_lifetime_delta)
	
	var c = color_array.pick_random()
	var image = Image.create(64,64, false, Image.FORMAT_RGBA8)	
	image.fill(c)
	var new_texture = ImageTexture.create_from_image(image)
	mesh_2d.texture = new_texture
	
	line.set_default_color(c)
	line.width = 2.0
	printerr("Starting point set @ "+str(global_position))
	line.add_point(global_position)
	
	add_to_group("walkers")
	set_scale(Vector2(8,8))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	step_time += delta
	if step_time > max_time:
		var choice = randi_range(0,3)
		
		# TODO activate rays and check cardinal directions
		# if any ray collides, add position to array of non-legal moves
		# if choice moves toward non legal move, *-1 to invert (or just stand still)
		if choice == 0:
			position.x += walk_speed
		elif choice == 1:
			position.x -= walk_speed
		elif choice == 2:
			position.y += walk_speed
		else:
			position.y -= walk_speed
		step_time = 0

func update_walk_speed(new_speed: float) -> void:
	if new_speed != walk_speed:
		walk_speed = new_speed

func _on_draw_timer_timeout():
	#print("Added point to line @ "+str(global_position))
	line.add_point(global_position)

func update_draw_speed(new_draw_time: float) -> void:
	if draw_timer:
		print("Found timer. New time set to: "+str(new_draw_time))
		draw_timer.stop()
		draw_timer.start(new_draw_time)
	else:
		print("No timer found.")
		
func _on_line_timer_timeout() -> void:
	var pc = line.get_point_count()
	if pc > 0:
		line.remove_point(0)

func update_line_lifetime(new_time: float) -> void:
	if line_timer:
		line_timer.stop()
		line_timer.start(new_time)

func set_values(walk_speed_: float, draw_delta_: float, line_lifetime_delta_: float, max_time_delta: float):
	walk_speed = walk_speed_
	draw_delta = draw_delta_
	line_lifetime_delta = line_lifetime_delta_
	max_time = max_time_delta

func update_step_time(new_value) -> void:
	max_time = new_value
