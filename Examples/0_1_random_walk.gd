extends Node2D

## Main control script
const WALKER = preload("res://Examples/walker.tscn")
var spawn_num: int = 1

## GUI
@onready var speed_slider = $CanvasLayer/GUI/MarginContainer/VBoxContainer/HBoxContainer/SpeedSlider
@onready var speed_viz = $CanvasLayer/GUI/MarginContainer/VBoxContainer/HBoxContainer/Viz

@onready var add_button = $CanvasLayer/GUI/MarginContainer/VBoxContainer/HBoxContainer5/AddButton
@onready var draw_steps_slider = $CanvasLayer/GUI/MarginContainer/VBoxContainer/HBoxContainer2/DrawStepsSlider
@onready var draw_viz = $CanvasLayer/GUI/MarginContainer/VBoxContainer/HBoxContainer2/Viz

@onready var spin_box = $CanvasLayer/GUI/MarginContainer/VBoxContainer/HBoxContainer5/SpinBox

@onready var line_lifetime_slider = $CanvasLayer/GUI/MarginContainer/VBoxContainer/HBoxContainer3/LineLifetimeSlider
@onready var line_lifetime_viz = $CanvasLayer/GUI/MarginContainer/VBoxContainer/HBoxContainer3/Viz

@onready var background_layer = $BackgroundLayer

@onready var step_time_slider = $CanvasLayer/GUI/MarginContainer/VBoxContainer/HBoxContainer4/StepTimeSlider
@onready var step_time_viz = $CanvasLayer/GUI/MarginContainer/VBoxContainer/HBoxContainer4/Viz



var draw_step_value: float = 0.1 # Draw ever .1 second
var line_lifetime_value: float = 0.15 # Oldest point removed after this value
var walk_speed_value: float = 1.0 # Move this distance on tick
var walker_step_time_max: float = 0.1 # Walker moves after this wait (0.1 seconds)

func _ready():
	for i in range(1):
		var w = WALKER.instantiate()
		add_child(w)
		w.add_to_group("walkers")
		w.set_values(walk_speed_value, draw_step_value, line_lifetime_value, walker_step_time_max)
	speed_viz.text = str(walk_speed_value)
	draw_viz.text = str(draw_step_value)
	line_lifetime_viz.text = str(line_lifetime_value)
	step_time_viz.text = str(walker_step_time_max)
	
func _on_speed_slider_drag_ended(value_changed):
	if value_changed:
		walk_speed_value = speed_slider.value
		get_tree().call_group("walkers", "update_walk_speed", walk_speed_value)
		speed_viz.text = str(walk_speed_value)
	# TODO - Allow for mouse selection (drag and drop) of groups of walkers.

func _on_draw_steps_slider_drag_ended(value_changed):
	if value_changed:
		draw_step_value = draw_steps_slider.value
		get_tree().call_group("walkers", "update_draw_speed", draw_step_value)
		draw_viz.text = str(draw_step_value)

func _on_line_lifetime_slider_drag_ended(value_changed):
	if value_changed:
		line_lifetime_value = line_lifetime_slider.value
		get_tree().call_group("walkers", "update_line_lifetime", line_lifetime_value)
		line_lifetime_viz.text = str(line_lifetime_value)

func _on_step_time_slider_drag_ended(value_changed):
	if value_changed:
		walker_step_time_max = step_time_slider.value
		get_tree().call_group("walkers", "update_step_time", walker_step_time_max)
		step_time_viz.text = str(walker_step_time_max)

## SPAWNING WALKERS -------------------------------- #
func _on_spin_box_value_changed(value):
	spawn_num = spin_box.value

func _on_add_button_button_up():
	for i in range(spawn_num):
		var w = WALKER.instantiate()
		w.set_position(Vector2(randi_range(250,1000), randi_range(250, 1000)))
		add_child(w)
		w.set_values(walk_speed_value, draw_step_value, line_lifetime_value, walker_step_time_max)
## ------------------------------------------------- #
