extends Node3D

@onready var left_controller = get_node("../../left_controller/")
@onready var right_controller = get_node("../../right_controller/")

@onready var sim_world = get_node("../../../simulation_origin")
@onready var playerOrigin = get_node("../../")

var scale_step:float = 0.1

var right_bool = false
var left_bool = false

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

func _ready():
	pass

func _process(delta):
	
	if right_bool:
		playerOrigin.world_scale += scale_step
	elif left_bool:
		playerOrigin.world_scale -= scale_step
