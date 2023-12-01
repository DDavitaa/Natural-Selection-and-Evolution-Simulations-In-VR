extends CharacterBody3D

@onready var nav_agent = get_node("NavigationAgent3D")

const SPEED = 1.0
const JUMP_VELOCITY = 4.5


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var current_location = global_transform.origin
	var next_location = get_node("NavigationAgent3D").get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = new_velocity
	move_and_slide()
	
func update_target_location(target_location):
	get_node("NavigationAgent3D").set_target_position(target_location)

