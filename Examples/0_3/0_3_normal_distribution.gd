extends Node2D
@onready var background = $BackgroundSprite
@onready var camera = $Camera2D
@onready var start_position = $StartPosition

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

# Column variables
var start_vector: Vector2
var columns: Array = []
var column_values: Array = [0,0,0,0,0,0,0,0,0,0]
var margin: float = 116.0

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
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(sort_number):
		num_array.append(rng.randi_range(0,100))
	
func _process(delta):
	step_time += delta
	
	if camera:
		background.global_position = camera.get_screen_center_position()
	
	if step_time > step_size:
		step_time = 0
		# Add a number to a column
		if num_array.size() > 0:
			var nn = num_array[-1]
			num_array.pop_back()
			var num_pos = floori(nn / 10)
			if num_pos == 10: # Handle exactly 100
				column_values[9] += 1
				columns[9].scale.y += 0.1
			else:
				column_values[num_pos] += 1
				columns[num_pos].scale.y += 0.1
			print(str(column_values) + " -> "+str(nn)+" index: "+str(num_pos))
		else:
			if not sorting_complete:
				print("Current sort complete!")
				sorting_complete = true
