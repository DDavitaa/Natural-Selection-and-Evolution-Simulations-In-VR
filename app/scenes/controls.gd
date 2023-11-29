extends Node3D

@onready var left_controller = get_node("../../left_controller/")
@onready var right_controller = get_node("../../right_controller/")

@onready var sim_world = get_node("../../../terrain_origin")

var dist_ctrl:float

var name_right = "0"
var name_left = "1"

var right_bool = false
var left_bool = false

func _ready():
	pass

func _on_right_controller_button_pressed(name):
	if(name == "grip_click"):
		#name_right = name
		right_bool = true

func _on_left_controller_button_pressed(name):
	if(name == "grip_click"):
		#name_left = name
		left_bool = true

func _on_right_controller_button_released(name):
	if(name == "grip_click"):
		#name_right = "0"
		right_bool = false
	
func _on_left_controller_button_released(name):
	if(name == "grip_click"):
		#name_left = "1"
		left_bool = false
		
func _input(event):
	#if event is InputEventJoypadButton:
		#print(event)
		#if event.button_index == BUTTON_YOUR_GRIP_BUTTON_INDEX:
			#if event.pressed:
				# Grip button pressed
				#print("Grip button pressed")
				#if event.device == left_controller:
				#	left_bool = true
				#elif event.device == right_controller:
				#	right_bool = true
			#elif event.released:
				# Grip button released
				#print("Grip button released")
				#if event.device == left_controller:
				#	left_bool = false
				#elif event.device == right_controller:
				#	right_bool = false
	print(event)

func _process(delta):
	dist_ctrl = left_controller.position.distance_to(right_controller.position)*1.5
	
	var right = false
	var left = false
	
	if right_bool:
		right = true
	else:
		right = false
		
	if left_bool:
		left = true
	else:
		left = false
	
	#print("name_right:", right)
	#print("name_left:", left)
		
	if right and left:
		print("yes")
		#sim_world.scale =+ Vector3(dist_ctrl,dist_ctrl,dist_ctrl)
	else:
		#print("no")
		pass
	
