extends Node2D
class_name WalkerAdvanced

@onready var mesh_2d = $MeshInstance2D
@onready var line = $Line2D
@onready var rays = $Rays
@onready var area_2d = $Area2D

var image: Image = null
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

var x_bias: float = 0.0
var y_bias: float = 0.0

var energy: float
var energy_max: float = 10
var is_sleeping: bool = false
var target_node: Node2D
var consumed = 0
var c: Color # Some color

# Called when the node enters the scene tree for the first time.
func _ready():
	energy = randf_range(3,10)
	draw_timer = Timer.new()
	add_child(draw_timer)
	draw_timer.timeout.connect(_on_draw_timer_timeout)
	draw_timer.start(draw_delta)
	
	line_timer = Timer.new()
	add_child(line_timer)
	line_timer.timeout.connect(_on_line_timer_timeout)
	line_timer.start(line_lifetime_delta)
	
	c = color_array.pick_random()
	image = Image.create(64,64, false, Image.FORMAT_RGBA8)
	image.fill(c)
	var new_texture = ImageTexture.create_from_image(image)
	mesh_2d.texture = new_texture
	
	line.set_default_color(c)
	line.width = 1.0
	printerr("Starting point set @ "+str(global_position))
	line.add_point(global_position)
	
	add_to_group("walkers")
	set_scale(Vector2(8,8))

func _process(delta):
	step_time += delta
	
	var rand = randf() # Randomly reset bias 5% of time
	if rand > 0.95:
		x_bias = 0
		y_bias = 0
		
	if target_node != null:
		if global_position.distance_to(target_node.global_position) > 50:
			# Reset if target is 50px away
			image.fill(c)
			var new_texture = ImageTexture.create_from_image(image)
			mesh_2d.texture = new_texture
			x_bias = 0
			y_bias = 0
		
		if global_position.distance_to(target_node.global_position) < 15 + (consumed * 5 + 1) and target_node.is_sleeping:
			x_bias = 0
			y_bias = 0
			energy += 10
			consumed += 1
			printerr("Consumed "+str(consumed)+" creatures.")
			scale.x += consumed/2
			scale.y += consumed/2
			target_node.queue_free()
			target_node = null
			if consumed > 12:
				var nc = c
				nc.a = 0.3
				image.fill(nc)
				var new_texture = ImageTexture.create_from_image(image)
				mesh_2d.texture = new_texture
				
			if consumed > 4:
				var nc = c
				nc.a = 0.8
				image.fill(nc)
				var new_texture = ImageTexture.create_from_image(image)
				mesh_2d.texture = new_texture
	
	if step_time > max_time and not is_sleeping:
		if energy > 0:
			set_ray_state(true)
			for ray in rays.get_children():
				if ray.is_colliding():
					var collider = ray.get_collider()
					if collider:
						var target = collider.get_parent()
						if target.is_sleeping:
							if target.scale.x < scale.x*2: # Can't eat big guys.
								target_node = target
								if ray.name == "RayDown":
									x_bias = 0
									y_bias = 2
								if ray.name == "RayUp":
									x_bias = 0
									y_bias = -2
								if ray.name == "RayLeft":
									x_bias = -2
									y_bias = 0
								if ray.name == "RayRight":
									x_bias = 2
									y_bias = 0

			var xchoice = randi_range((-walk_speed-consumed),walk_speed+consumed)+x_bias
			var ychoice = randi_range((-walk_speed-consumed),walk_speed+consumed)+y_bias
			position.x += xchoice
			position.y += ychoice
			step_time = 0
			energy -= 0.05
		else:
			set_ray_state(false)
			is_sleeping = true
			image.fill(Color.BLACK)
			var new_texture = ImageTexture.create_from_image(image)
			mesh_2d.texture = new_texture
		
	
	if is_sleeping:
		energy += 2.5 * delta
		if energy > energy_max:
			x_bias = 0
			y_bias = 0
			is_sleeping = false
			image.fill(c)
			var new_texture = ImageTexture.create_from_image(image)
			mesh_2d.texture = new_texture
		
func update_walk_speed(new_speed: float) -> void:
	if new_speed != walk_speed:
		walk_speed = new_speed

func _on_draw_timer_timeout():
	line.add_point(global_position)

func update_draw_speed(new_draw_time: float) -> void:
	if draw_timer:
		#print("Found timer. New time set to: "+str(new_draw_time))
		draw_timer.stop()
		draw_timer.start(new_draw_time)
	else:
		printerr("No timer found in "+self.name)
		
func _on_line_timer_timeout() -> void:
	var pc = line.get_point_count()
	if pc > 0:
		line.remove_point(0)

func update_line_lifetime(new_time: float) -> void:
	if line_timer:
		line_timer.stop()
		line_timer.start(new_time)

func set_values(walk_speed_: float, draw_delta_: float, line_lifetime_delta_: float, max_time_delta: float, new_x_bias: float, new_y_bias: float):
	walk_speed = walk_speed_
	draw_delta = draw_delta_
	line_lifetime_delta = line_lifetime_delta_
	max_time = max_time_delta
	x_bias = new_x_bias
	y_bias = new_y_bias

func update_step_time(new_value) -> void:
	max_time = new_value

func update_xy_bias(x_bias_: float, y_bias_: float) -> void:
	x_bias = x_bias_
	y_bias = y_bias_

func set_ray_state(ray_state_enable: bool) -> void:
	for r in rays.get_children():
		r.enabled = ray_state_enable
