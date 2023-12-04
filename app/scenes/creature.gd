extends CharacterBody3D

@onready var nav_agent = get_node("NavigationAgent3D")
@onready var terrain = get_node("../")
@onready var cam = get_node("../../../env/Camera3D")
@onready var xrcam = get_node("../../../player - origin/PlayerBody")
@onready var rootNode = get_node("../../../")

var SPEED = 1.0
const JUMP_VELOCITY = 4.5

var wander_range:float = 5.0
var time_to_change_direction:float = 4.0
var stop_in_place = false
var elapsed_time:float = 0.0
var random_location:Vector3 = Vector3.ZERO

var food_found = false
var food_location:Vector3 = Vector3.ZERO

var kill_creature = false
var run_from_creature = false
var otherCreature_location:Vector3 = Vector3.ZERO
var otherCreature:CharacterBody3D

var rng = RandomNumberGenerator.new()
var label = Label3D.new()
var creature_color = StandardMaterial3D.new()
var sound = AudioStreamPlayer3D.new()

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	label.scale = Vector3(3,3,3)
	
	add_child(label)
	
	creature_color.albedo_color = Color(0.659, 0.388, 0.176)
	$CollisionShape3D/MeshInstance3D.set_surface_override_material(0,creature_color)
	
	add_child(sound)
	sound.volume_db = -15.0
	sound.stream = load("res://audio/523769__matrixxx__retro-hit.wav")
	sound.playing = true
	#sound.emission_angle_enabled = true
	

func _physics_process(delta):
	elapsed_time += delta
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	# wandering
	if food_found == false && kill_creature == false && run_from_creature == false:
		if elapsed_time >= time_to_change_direction:
			
			stop_in_place = rand_trueFalse()
			
			if stop_in_place:
				update_target_location(global_position)
				time_to_change_direction = randf_range(0.5,1.5)
			else:
				random_location = Vector3(randf_range(-wander_range,wander_range),0,randf_range(-wander_range,wander_range))
				update_target_location(random_location)
				look_at(random_location, Vector3.UP)
				time_to_change_direction = randf_range(3.0,10.0)
			
			elapsed_time = 0.0
			
	elif kill_creature == true && otherCreature:
		$CollisionShape3D/MeshInstance3D.get_surface_override_material(0).albedo_color = Color(0.792, 0.702, 0) # yellow
		update_target_location(otherCreature.global_position)
		look_at(otherCreature_location, Vector3.UP)
		
	elif run_from_creature == true && otherCreature:
		$CollisionShape3D/MeshInstance3D.get_surface_override_material(0).albedo_color = Color(0.621, 0.611, 0.609) # gray
		update_target_location(-otherCreature.global_position)
		look_at(-otherCreature_location, Vector3.UP)
		
	elif food_found == true && kill_creature == false && run_from_creature == false:
		update_target_location(food_location)
		look_at(food_location, Vector3.UP)
	
	rotation = Vector3(0,rotation.y,0)
	
	var current_location = global_position
	var next_location = get_node("NavigationAgent3D").get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = new_velocity
	move_and_slide()
	
func _process(delta):
	label.global_position = global_position
	label.global_position.y += 1
	
	if rootNode.is_using_xr:
		label.look_at(xrcam.global_position, Vector3.UP)
	else:
		label.look_at(cam.global_position, Vector3.UP)
	
	label.rotate_object_local(Vector3.UP, PI)
	
	label.text = "SCALE: " + str(snappedf($CollisionShape3D.scale.y,0.01)) + "\nSPEED: " + str(SPEED) + "\nkilling: " + str(kill_creature) + "\nrunning_away: " + str(run_from_creature)
	
func update_target_location(target_location):
	get_node("NavigationAgent3D").set_target_position(target_location)
	
func rand_trueFalse():
	var decide = rng.randi_range(0,1)
	
	if decide == 0:
		return false
	else:
		return true

# food detected
func _on_area_3d_area_entered(area):
	if food_location == Vector3.ZERO:
		if area.is_in_group("food_area"):
			food_found = true
			food_location = area.global_position

func _on_area_3d_area_exited(area):
	if area.is_in_group("food_area"):
		food_found = false
		food_location = Vector3.ZERO
	

# creatures detected
func _on_area_3d_body_entered(body):
	if otherCreature_location == Vector3.ZERO:
		if body.is_in_group("creatures"):
			if self.scale > body.scale:
				if !run_from_creature:
					kill_creature = rand_trueFalse()
					otherCreature = body
					
			elif self.scale < body.scale:
				if body.kill_creature:
					otherCreature = body
					run_from_creature = true
					kill_creature = false
					
			elif self.scale == body.scale:
				kill_creature = false
				run_from_creature = false

func _on_area_3d_body_exited(body):
	if body.is_in_group("creatures"):
		if self.scale > body.scale:
			$CollisionShape3D/MeshInstance3D.get_surface_override_material(0).albedo_color = Color(0.659, 0.388, 0.176) 
			kill_creature = false
			otherCreature = null
		elif self.scale < body.scale:
			$CollisionShape3D/MeshInstance3D.get_surface_override_material(0).albedo_color = Color(0.659, 0.388, 0.176)
			run_from_creature = false
			otherCreature = null
		elif self.scale == body.scale:
			kill_creature = false
			run_from_creature = false
			

# if creature has collided with another creature
func _on_area_3d_2_body_entered(body):
	if body.is_in_group("creatures"):
		if body.scale > scale && body.kill_creature == true:
			sound.play()
			queue_free()
