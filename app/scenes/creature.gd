extends CharacterBody3D

@onready var nav_agent = get_node("NavigationAgent3D")
@onready var terrain = get_node("../../")

const SPEED = 1.0
const JUMP_VELOCITY = 4.5

var hungry = true

var timer = Timer.new()
var rng = RandomNumberGenerator.new()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var current_location = global_position
	var next_location = get_node("NavigationAgent3D").get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = new_velocity
	move_and_slide()
	
func update_target_location(target_location):
	get_node("NavigationAgent3D").set_target_position(target_location)


func _on_area_3d_body_entered(body):
	#if body.name == "food":
	#	get_tree().call_group("creatures_1","update_target_location",food.global_position)
	pass
	#TODO: whenever food is in range, hunger countdown
