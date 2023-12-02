extends Node3D

@onready var left_controller = get_node("../../left_controller/")
@onready var right_controller = get_node("../../right_controller/")

@onready var sim_world = get_node("../../../simulation_origin")

var scale_step:float = 0.05
var max_scale = 1.0  # Adjust this value as needed
var min_scale = 0.05

var right_bool = false
var left_bool = false

func _ready():
	pass

func _on_right_controller_button_pressed(name):
	if(name == "by_button"):
		right_bool = true

func _on_left_controller_button_pressed(name):
	if(name == "by_button"):
		left_bool = true

func _on_right_controller_button_released(name):
	if(name == "by_button"):
		right_bool = false
	
func _on_left_controller_button_released(name):
	if(name == "by_button"):
		left_bool = false

func _process(delta):
	
	if right_bool:
		sim_world.scale *= Vector3(1.0 + scale_step, 1.0 + scale_step, 1.0 + scale_step)
		sim_world.scale = sim_world.scale.clamp(Vector3(min_scale, min_scale, min_scale), Vector3(max_scale, max_scale, max_scale))
	elif left_bool:
		sim_world.scale *= Vector3(1.0 - scale_step, 1.0 - scale_step, 1.0 - scale_step)
		sim_world.scale = sim_world.scale.clamp(Vector3(min_scale, min_scale, min_scale), Vector3(max_scale, max_scale, max_scale))
