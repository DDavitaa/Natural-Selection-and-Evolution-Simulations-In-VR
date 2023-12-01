extends Node3D

@onready var left_controller = get_node("../../left_controller/")
@onready var right_controller = get_node("../../right_controller/")

@onready var sim_world = get_node("../../../terrain_origin")

var dist_ctrl:float

var right_bool = false
var left_bool = false

func _ready():
	pass

func _on_right_controller_button_pressed(name):
	if(name == "grip_click"):
		right_bool = true

func _on_left_controller_button_pressed(name):
	if(name == "grip_click"):
		left_bool = true

func _on_right_controller_button_released(name):
	if(name == "grip_click"):
		right_bool = false
	
func _on_left_controller_button_released(name):
	if(name == "grip_click"):
		left_bool = false

func _process(delta):
	dist_ctrl = left_controller.position.distance_to(right_controller.position)*1.5
		
	if left_bool:
		print("yes")
		sim_world.scale =+ Vector3(dist_ctrl,dist_ctrl,dist_ctrl)
	
