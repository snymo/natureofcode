extends Node2D
class_name PerlinNoise

@onready var random_range_start = $RandomRangeStart
@onready var perlin_noise_start = $PerlinNoiseStart
@onready var simplex_smooth_start = $SimplexSmoothStart
@onready var gaussian_distribution_start = $GaussianDistributionStart

var move_dist_x: float = 5.0 # Horizontal movement
var countdown: float = 1.0
var countdown_max := 1.0
const MAX_LINE_POINTS = 350

## Random Range
var rr_noise: float
var rr_line: Line2D
var rr_start_pos: Vector2
var rr_current_pos: Vector2

## Perlin Noise
var p_noise : FastNoiseLite
var p_line: Line2D
var p_start_pos: Vector2
var p_current_pos: Vector2

## Simplex Smooth
var ss_noise: FastNoiseLite
var ss_line: Line2D
var ss_start_pos: Vector2
var ss_current_pos: Vector2

## Gaussian Distribution
var g_noise: float
var g_line: Line2D
var g_start_pos: Vector2
var g_current_pos: Vector2



func _ready():
	# Random Range Line
	rr_line = Line2D.new()
	rr_line.width = 2.0
	rr_line.global_position = random_range_start.global_position
	add_child(rr_line)
	rr_line.add_point(rr_start_pos)
	rr_current_pos = rr_start_pos
	
	# Perlin Noise Line
	p_line = Line2D.new()
	p_line.width = 2.0
	p_line.global_position = perlin_noise_start.global_position
	add_child(p_line)
	p_line.set_default_color(Color.YELLOW)
	p_line.add_point(p_start_pos)
	p_current_pos = p_start_pos
	p_noise = FastNoiseLite.new()
	p_noise.frequency = 0.5
	p_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	
	# Simplex Smooth
	ss_line = Line2D.new()
	ss_line.width = 2.0
	ss_line.global_position = simplex_smooth_start.global_position
	ss_line.set_default_color(Color.CHARTREUSE)
	add_child(ss_line)
	ss_line.add_point(ss_start_pos)
	ss_current_pos = ss_start_pos
	ss_noise = FastNoiseLite.new()
	ss_noise.frequency = 0.5
	ss_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	
	# Gaussian / Normal Distribution
	g_line = Line2D.new()
	g_line.width = 2.0
	g_line.global_position = gaussian_distribution_start.global_position
	g_line.set_default_color(Color.DARK_ORANGE)
	add_child(g_line)
	g_line.add_point(g_start_pos)
	g_current_pos = g_start_pos

func _process(delta):
	if rr_line.get_point_count() < MAX_LINE_POINTS:
		countdown -= delta*60
		
		if countdown <= 0:
			countdown = countdown_max
			make_random_range()
			make_perlin_noise()
			make_simplex_noise()
			make_normal_noise()
		print(rr_line.get_point_count())

func make_random_range() -> void:
		var new_x = rr_current_pos.x + move_dist_x
		var new_y = randf_range(-20,20)
		rr_line.add_point(Vector2(new_x, new_y))
		rr_current_pos = Vector2(new_x, new_y)

func make_perlin_noise() -> void:
		var new_x = p_current_pos.x + move_dist_x
		var new_y = p_noise.get_noise_1d(new_x) * 100
		p_line.add_point(Vector2(new_x, new_y))
		p_current_pos = Vector2(new_x, new_y)

func make_simplex_noise() -> void:
		var new_x = ss_current_pos.x + move_dist_x
		var new_y = ss_noise.get_noise_1d(new_x) * 60
		ss_line.add_point(Vector2(new_x, new_y))
		ss_current_pos = Vector2(new_x, new_y)

func make_normal_noise() -> void:
		var new_x = g_current_pos.x + move_dist_x
		var new_y = randfn(0, 15)
		g_line.add_point(Vector2(new_x, new_y))
		g_current_pos = Vector2(new_x, new_y)
