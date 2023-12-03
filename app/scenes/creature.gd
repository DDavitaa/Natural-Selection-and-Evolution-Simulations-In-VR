extends CharacterBody3D

@onready var nav_agent = get_node("NavigationAgent3D")
@onready var terrain = get_node("../")

var SPEED = 1.0
const JUMP_VELOCITY = 4.5

var health:int = 10
var hungry = true
var wander_range:float = 5.0
var time_to_change_direction:float = randf_range(2.0,6.0)
var stop_in_place = false
var elapsed_time:float = 0.0
var random_location:Vector3 = Vector3.ZERO
var food_found = false

var hungerTimer = Timer.new()
var rng = RandomNumberGenerator.new()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	# wandering
	if food_found == false:
		if elapsed_time >= time_to_change_direction:
			var decide_to_stop = rng.randi_range(0,1)
			
			if decide_to_stop == 0:
				stop_in_place = false
			else:
				stop_in_place = true
			
			if stop_in_place:
				update_target_location(global_position)
			else:
				random_location = Vector3(randf_range(-wander_range,wander_range),0,randf_range(-wander_range,wander_range))
				update_target_location(random_location)
				look_at(random_location, Vector3.UP)
			
			rotation = Vector3(0,rotation.y,0)
			elapsed_time = 0.0
			time_to_change_direction = randf_range(2.0,6.0)
	else:
		pass
	
	var current_location = global_position
	var next_location = get_node("NavigationAgent3D").get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = new_velocity
	move_and_slide()
	
func _process(delta):
	elapsed_time += delta
	
func update_target_location(target_location):
	get_node("NavigationAgent3D").set_target_position(target_location)

func _on_area_3d_body_entered(body):
	if body.name == "food":
		food_found = true
	#TODO: whenever food is in range, hunger countdown


func _on_area_3d_body_exited(body):
	if body.name == "food":
		food_found = false
