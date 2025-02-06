extends Node2D
@onready var background = $BackgroundSprite
@onready var camera = $Camera2D
@onready var start_position = $StartPosition
@onready var spin_box = $CanvasLayer/GUI/MarginContainer/VBoxContainer/HBoxContainer/SpinBox
@onready var dev_slider = $CanvasLayer/GUI/MarginContainer/VBoxContainer/HBoxContainer3/HSlider
@onready var gui = $CanvasLayer/GUI
@onready var sort_label = $CanvasLayer/GUI/SortLabel

# TODO 
# Make 10 pillars in a line
# Assign each pillar a value of 10 between 0 and 100. 0-9, 10-20 etc.
# Generate a list of 100 numbers from 0 to 100. 
# For each number generated, increase the height of the correct column.

# Simulation variables
var step_size: float = 0.01 # The speed of the graph updates.
var step_time: float = 0.0 # Current time. Increases to step_size
var sorting_complete: bool = false 
var sort_number: int = 500 # How many numbers to generate and sort.
var sorting: bool = false
var sort_type: String = "gaussian"
var standard_dev: float = 15.0 # Standard deviation used

# Column variables
var start_vector: Vector2
var columns: Array = []
var column_values: Array = [0,0,0,0,0,0,0,0,0,0]
var margin: float = 116.0
var increase_value: float = 0.1

# Numbers
var num_array: Array = []

func _ready():
	## Background Setup
	background.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	background.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	var viewport_size = get_viewport_rect().size
	background.scale = (viewport_size / background.texture.get_size()) * 1.1
	
	## Column Setup
	for i in range(10):
		var newcolumn = Sprite2D.new()
		var img = Image.create(50, 50, false, Image.FORMAT_RGB8)
		img.fill(Color.DARK_GOLDENROD)
		newcolumn.texture = ImageTexture.create_from_image(img)
		newcolumn.global_position = start_position.global_position # Set global position
		newcolumn.position.x = newcolumn.position.x + (i*margin)
		newcolumn.offset = Vector2(0,-25)
		add_child(newcolumn)
		columns.append(newcolumn)

func _process(delta):
	step_time += delta
	
	if camera:
		background.global_position = camera.get_screen_center_position()
	
	if sorting:
		if step_time > step_size:
			step_time = 0
			# Add a number to a column
			if num_array.size() > 0:
				var nn = num_array[-1]
				num_array.pop_back()
				var num_pos = floori(nn / 10)
				if num_pos == 10: # Handle exactly 100
					column_values[9] += 1
					columns[9].scale.y += increase_value
				else:
					column_values[num_pos] += 1
					columns[num_pos].scale.y += increase_value
				print(str(column_values) + " -> "+str(nn)+" index: "+str(num_pos))
			else:
				if not sorting_complete:
					print("Current sort complete!")
					sorting_complete = true

func generate_numbers(num_int: int, sort_name: String = "none") -> void:
	num_array.clear()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	match sort_type:
		"none":  # Uniform distribution
			sort_label.text = "Uniform Distribution"
			for i in range(sort_number):
				num_array.append(rng.randi_range(0,100))
		
		"gaussian":  # Normal distribution
			sort_label.text = "Gaussian Distribution"
			for i in range(sort_number):
				var ii = floor(rng.randfn(50, standard_dev))
				ii = clampi(ii, 0, 100)
				num_array.append(ii)
		
		"bimodal":  # Two peaks
			sort_label.text = "Bimodal Distribution"
			for i in range(sort_number):
				var peak = rng.randi() % 2
				if peak == 0:
					num_array.append(clampi(floor(rng.randfn(25, 10)), 0, 100))
				else:
					num_array.append(clampi(floor(rng.randfn(75, 10)), 0, 100))
		
		"exponential":  # Higher numbers are rarer
			sort_label.text = "Exponential Distribution"
			for i in range(sort_number):
				var ii = -log(1 - rng.randf()) * 20  # Adjust 20 to control spread
				ii = clampi(floor(ii), 0, 100)
				num_array.append(ii)
		
		"triangular":  # Linear increase then decrease
			sort_label.text = "Triangular Distribution"
			for i in range(sort_number):
				num_array.append(clampi(floor(rng.randf_range(0, 100) + rng.randf_range(0, 100)) / 2, 0, 100))

func _on_start_button_button_up():
	sorting = true
	sort_number = spin_box.value
	generate_numbers(sort_number, sort_type)

func _on_reset_button_button_up():
	sorting = false
	num_array.clear()
	for c in columns:
		c.scale.y = 1
	dev_slider.set_value_no_signal(15)


func _on_popup_menu_id_pressed(id):
	match id:
		1:
			sort_type = "none"
			print("Sort type is: "+sort_type)
		2:
			sort_type = "gaussian"
			print("Sort type is: "+sort_type)
		3:
			sort_type = "bimodal"
			print("Sort type is: "+sort_type)
		4:
			sort_type = "exponential"
			print("Sort type is: "+sort_type)
		5:
			sort_type = "triangular"
			print("Sort type is: "+sort_type)

func _on_h_slider_drag_ended(value_changed):
	standard_dev = floor(dev_slider.value)
	print("Standard deviation: "+str(standard_dev))
