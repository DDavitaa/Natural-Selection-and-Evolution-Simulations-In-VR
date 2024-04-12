extends CharacterBody3D

@onready var nav_agent = get_node("NavigationAgent3D")
@onready var terrain = get_node("../")
@onready var cam = get_node("../../../env/Camera3D")
@onready var xrcam = get_node("../../../player - origin/PlayerBody")
@onready var rootNode = get_node("../../../")

@onready var healthbar = $"SubViewport/Bars/HealthBar"
@onready var energybar = $"SubViewport/Bars/EnergyBar"
@onready var infoGui = $Viewport2Din3D

@onready var atkTimer = $AttackTimer

var creature_id:int = 0
var colour_names = ["Brown","Red","Yellow","Green","Blue"]
var colour_codes = [Color(0.659,0.388,0.176),Color(0.74, 0, 0),Color(0.8, 0.85, 0),Color(0, 0.45, 0),Color(0, 0, 0.94),Color(0.74, 0, 0)]
var colour_dead = Color(1,1,1)

# MAX VALUES FROM USER
var gui_COLOUR:int = 0
var gui_HEALTH:float = 10 # 3 - 20
var gui_ENERGY:float = 200 # 100 - 500
var gui_SIZE:float = 0.2 # 0.05 - 0.06
var gui_SPEED:float = 1 # 0.5 - 2 #
var gui_MASS:float = 80 # 50 - 150
var gui_ATK:float = 4 # 1 - 10
var gui_DEF:float = 4 # 1 - 10
var gui_LOS:float = 10 # 1 - 10 (Line of sight distance)
var gui_IS_CARNIVORE:bool = false

# PARAMETERS
var HEALTH:float = gui_HEALTH
var ENERGY:float = gui_ENERGY
var SIZE:float = gui_SIZE 
var SPEED:float = gui_SPEED 
var MASS:float = gui_MASS
var ATK:float = gui_ATK
var DEF:float = gui_DEF
var LINEOFSIGHT_DIST:float = gui_LOS 
var IS_CARNIVORE:bool = gui_IS_CARNIVORE

# OTHER PARAMETERS
var reproduction_chance:float = 0.1

# -------------------------------

# FOR ENERGY
var elapsed_time_ENERGY:float = 0
var accumulated_energy_cost:float = 0
var elapsed_time_ENERGYLOW:float = 0

# FOR STATES
var elapsed_time_WANDER:float = 0
var wander_range:float = 5
var time_to_change_direction:float = 2
var stop_in_place = false
var random_location:Vector3 = Vector3.ZERO
var isWandering:bool = false

var located_plant:Vector3 = Vector3.ZERO
var located_creature:CharacterBody3D = null
var plantlock:bool = false
var creaturelock:bool = false
var elapsed_time_ATTACK:float = 0
var attacking:bool = false

var reproduce:bool = false
var reproducing:bool = false
var parent_index:int = 0

var isFighting:bool = false
var buffLock = false
var elapsed_time_buffLock:float = 0

var IS_DEAD:bool = false
var elapsed_time_DEAD:float = 0

# reproduction
var parent1_id:int
var parent2_id:int

var inherited_COLOUR = []
var inherited_HEALTH = []
var inherited_ENERGY = []
var inherited_SIZE = []
var inherited_SPEED = []
var inherited_MASS= []
var inherited_ATK = []
var inherited_DEF = []
var inherited_LINEOFSIGHT_DIST = []
var inherited_IS_CARNIVORE = []


# ICONS
var wanderIcon = preload("res://textures/steps-icon.png")
var findFoodIcon = preload("res://textures/dish-spoon-knife-icon.png")
var fightIcon = preload("res://textures/crossed-swords-icon.png")
var fleeIcon = preload("res://textures/running-icon.png")
var findMateIcon = preload("res://textures/find-partner-icon.png")
var heartIcon = preload("res://textures/red-heart-icon.png")
var deadIcon = preload("res://textures/skull-icon.png")

var rng = RandomNumberGenerator.new()
var label = Label3D.new()
var creature_color = StandardMaterial3D.new()

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	label.scale = Vector3(3,3,3)
	
	add_child(label)
	
	creature_color.albedo_color = colour_codes[gui_COLOUR]
	$CollisionShape3D/MeshInstance3D.set_surface_override_material(0,creature_color)
	

func _physics_process(delta):	
	# gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	
func _process(delta):
	
	# LABELS AND BARS
	label.global_position = global_position
	label.global_position.y += 0.7

	if rootNode.is_using_xr:
		label.look_at(xrcam.global_position, Vector3.UP)
		$spriteIcon.look_at(xrcam.global_position, Vector3.UP)
		$sprite_healthbar.look_at(xrcam.global_position, Vector3.UP)
		infoGui.look_at(xrcam.global_position, Vector3.UP)
	else:
		label.look_at(cam.global_position, Vector3.UP)
		$spriteIcon.look_at(cam.global_position, Vector3.UP)
		$sprite_healthbar.look_at(cam.global_position, Vector3.UP)
		infoGui.look_at(cam.global_position, Vector3.UP)

	label.rotate_object_local(Vector3.UP, PI)
	$sprite_healthbar.rotate_object_local(Vector3.UP, PI)
	infoGui.rotate_object_local(Vector3.UP, PI)
	
	healthbar.max_value = gui_HEALTH
	healthbar.value = HEALTH
	energybar.max_value = gui_ENERGY
	energybar.value = ENERGY

	label.text = "CREATURE ID: " + str(creature_id)
	
	# -------- stats processing ----------
	elapsed_time_WANDER += delta
	elapsed_time_ENERGY += delta
	
	# if health is 0
	if HEALTH <= 0:
		$StateChart.send_event("dead")
	
	# if energy levels are low then slow down
	if ENERGY < (gui_ENERGY*0.2):
		SPEED = gui_SPEED * 0.5
		
		# if energy is too low, then start taking damage
		if ENERGY < (gui_ENERGY*0.02):
			elapsed_time_ENERGYLOW += delta
			if elapsed_time_ENERGYLOW > 2:
				HEALTH -= 0.5
				elapsed_time_ENERGYLOW = 0.0
	else:
		SPEED = gui_SPEED
	
	
	$"lineOfSight_area/CollisionShape3D".scale = Vector3(LINEOFSIGHT_DIST,LINEOFSIGHT_DIST,LINEOFSIGHT_DIST)
	
	if plantlock and located_plant == Vector3.ZERO:
		plantlock = false
		$StateChart.send_event("wander")
	elif creaturelock and located_creature == null:
		creaturelock = false
		$StateChart.send_event("wander")
	
	
func update_target_location(target_location):
	get_node("NavigationAgent3D").set_target_position(target_location)
	
func rand_trueFalse():
	var decide = rng.randi_range(0,1)
	
	if decide == 0:
		return false
	else:
		return true

func update_energy():
	var creature_velocity:float = velocity.length() * 1.1
	var is_resting:bool = creature_velocity < 0.3
	
	# energy updates every 2 seconds
	if elapsed_time_ENERGY < 2:
		
		# formula: KE = 1/2 * MASS * VELOCITY^2
		var kineticEnergy:float = 0.5 * MASS * creature_velocity * creature_velocity
		accumulated_energy_cost += kineticEnergy
		
	else:
		var final_energy_cost = accumulated_energy_cost/1000
		ENERGY = snappedf(ENERGY - final_energy_cost,0.1)
		
		accumulated_energy_cost = 0.0
		elapsed_time_ENERGY = 0.0


func calculate_combat_confidence():
	var max_attack_defense = 10.0
	
	var normalized_health = HEALTH / gui_HEALTH
	var normalized_energy = ENERGY / gui_ENERGY
	
	var ego_factor = 5.0
	var normalized_attack = ATK / max_attack_defense
	var normalized_defence = DEF / max_attack_defense
	var ego_boost = (normalized_attack+normalized_defence) * ego_factor / gui_ENERGY
	
	var base_confidence = (normalized_health * 0.4 + normalized_energy * 0.4)
	
	var size_difference = SIZE - located_creature.SIZE
	var size_modifier = clamp(size_difference / 10.0, -0.2, 0.2)
	
	var combat_confidence = base_confidence + ego_boost + size_modifier
	combat_confidence = clamp(combat_confidence, 0.0, 1.0)
	
	var is_confident = combat_confidence > 0.6
	print(str(creature_id) + ": COMBAT " + str(is_confident))
	return is_confident
	

func calculate_damage():
	var defense_modifier = max(0.5, 1 - (located_creature.DEF / (ATK + located_creature.DEF)))
	
	var damage = ATK * defense_modifier
	
	return max(damage, 0.5)
	
func calculate_reproduction():
	var parent1 = self
	var parent2 = located_creature
	var mutation_factor = 1.0
	
	var healths = [parent1.gui_HEALTH,parent2.gui_HEALTH]
	var energies = [parent1.gui_ENERGY,parent2.gui_ENERGY]
	var sizes = [parent1.SIZE,parent2.gui_ENERGY]
	var speeds = [parent1.SPEED,parent2.gui_ENERGY]
	var masses = [parent1.MASS,parent2.MASS]
	var attacks = [parent1.ATK,parent2.ATK]
	var defences = [parent1.DEF,parent2.DEF]
	var LOSes = [parent1.LINEOFSIGHT_DIST,parent2.LINEOFSIGHT_DIST]
	var diets = [parent1.IS_CARNIVORE,parent2.IS_CARNIVORE]
	
	if rng.randf() < 0.1:
		mutation_factor = rng.randf_range(1.1,1.5) 
	
	var offspring_health = healths[rng.randi() % 2]
	var offspring_energy = energies[rng.randi() % 2]
	var offspring_size = sizes[rng.randi() % 2]
	var offspring_speed = speeds[rng.randi() % 2] * mutation_factor
	var offspring_mass = masses[rng.randi() % 2]
	var offspring_atk = attacks[rng.randi() % 2]
	var offspring_def = defences[rng.randi() % 2]
	var offspring_los = LOSes[rng.randi() % 2]
	var offspring_diet = diets[rng.randi() % 2]
	
	terrain.gen_offspring(parent1,offspring_health,offspring_energy,offspring_size,offspring_speed,offspring_mass,offspring_atk,offspring_def,offspring_los,offspring_diet)

# LOCATING FOOD ---------------------------------------
func _on_line_of_sight_area_area_entered(area):
	# prevents another food from being tracked
	if !plantlock and !IS_CARNIVORE:
		if area.is_in_group("food_area"):
			located_plant = area.global_position
			plantlock = true

func _on_line_of_sight_area_area_exited(area):
	if area.is_in_group("food_area"):
		located_plant = Vector3.ZERO
		plantlock = false

# LOCATING CREATURES ----------------------------------
func _on_line_of_sight_area_body_entered(body):
	if body.is_in_group("creature"):
		# if both creatures' health and energies are high, and both are the same colour
		if !creaturelock and HEALTH > gui_HEALTH*0.8 and ENERGY > gui_ENERGY*0.8 and body.HEALTH > body.gui_HEALTH*0.8 and body.ENERGY > body.gui_ENERGY*0.8 and body.gui_COLOUR == self.gui_COLOUR and !reproduce:
			reproduce = rng.randf_range(0,1) <= reproduction_chance
			
			if reproduce:
				located_creature = body
				creaturelock = true
				parent_index = 1
				$StateChart.send_event("findmate")
		
		# if another creature wants to mate with self
		if !creaturelock and body.reproduce and body.located_creature == self:
			reproduce = true
			located_creature = body
			creaturelock = true
			parent_index = 2
			$StateChart.send_event("findmate")
		
		# if preyed on
		if !creaturelock and body.isFighting and body.located_creature == self:
			located_creature = body
			creaturelock = true
			isFighting = true
			if calculate_combat_confidence():
				$StateChart.send_event("fight")
			else:
				$StateChart.send_event("flee")
		
		# if carnivore has low energy
		if !creaturelock and IS_CARNIVORE and (ENERGY < gui_ENERGY*0.5) and body.gui_COLOUR != gui_COLOUR:
			located_creature = body
			creaturelock = true
			isFighting = true
			if calculate_combat_confidence():
				$StateChart.send_event("fight")
			else:
				$StateChart.send_event("flee")
				
	

func _on_line_of_sight_area_body_exited(body):
	if body.is_in_group("creature"):
		if located_creature == body:
			located_creature = null
			creaturelock = false
			isFighting = false
			reproduce = false
			$StateChart.send_event("wander")
	

# REACH AREA
func _on_reach_area_body_entered(body):
	if body.is_in_group("creature"):
		# if another creature wants to mate with self
		if !creaturelock and body.reproduce and body.located_creature == self:
			reproduce = true
			located_creature = body
			creaturelock = true
			parent_index = 2
			$StateChart.send_event("findmate")
		if body == located_creature and isFighting:
			attacking = true
		if body == located_creature and reproduce:
			reproducing = true
			
			if parent_index == 1:
				calculate_reproduction()
		
	

func _on_reach_area_body_exited(body):
	if body.is_in_group("creature"):
		if located_creature == body and attacking:
			attacking = false
			$StateChart.send_event("wander")
		if located_creature == body and reproducing:
			reproducing = false
			$StateChart.send_event("wander")

# ------------------------------------------------------------------
############################ STATES ##################################
# ------------------------------------------------------------------

# ================== WANDERING ==================
func _on_wander_state_physics_processing(delta):
	$spriteIcon.texture = wanderIcon
	
	isWandering = true
	
	# if energy levels drop below 50%, then look for food
	if (ENERGY < (gui_ENERGY*0.5) or HEALTH < (gui_HEALTH*0.5)) and isWandering:
		$StateChart.send_event("lookforfood")
	
	# WANDER
	if elapsed_time_WANDER >= time_to_change_direction:

		stop_in_place = rand_trueFalse()

		if stop_in_place:
			update_target_location(global_position)
			time_to_change_direction = randf_range(0.5,1.5)
		else:
			random_location = Vector3(randf_range(-wander_range,wander_range),0,randf_range(-wander_range,wander_range))
			update_target_location(random_location)
			look_at(random_location, Vector3.UP)
			time_to_change_direction = randf_range(2.0,10.0)

		elapsed_time_WANDER = 0.0
	
	update_energy()
	
	rotation = Vector3(0,rotation.y,0)
	
	var current_location = global_position
	var next_location = get_node("NavigationAgent3D").get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = new_velocity
	move_and_slide()

# ================== LOOKING FOR FOOD ==================
func _on_look_for_food_state_physics_processing(delta):
	$spriteIcon.texture = findFoodIcon
	
	# actively look for food
	if elapsed_time_WANDER >= time_to_change_direction:
		random_location = Vector3(randf_range(-wander_range,wander_range),0,randf_range(-wander_range,wander_range))
		update_target_location(random_location)
		look_at(random_location, Vector3.UP)
		time_to_change_direction = randf_range(2.0,5.0)

		elapsed_time_WANDER = 0.0
	
	update_energy()
	
	
	if located_plant != Vector3.ZERO and !IS_CARNIVORE:
		update_target_location(located_plant)
		look_at(located_plant, Vector3.UP)
		
		
	rotation = Vector3(0,rotation.y,0)
	
	var current_location = global_position
	var next_location = get_node("NavigationAgent3D").get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = new_velocity
	move_and_slide()


func _on_fight_state_physics_processing(delta):
	$spriteIcon.texture = fightIcon
	
	isWandering = false
	
	
	
	if !located_creature:
		$StateChart.send_event("wander")
	else:
		update_target_location(located_creature.global_position)
		look_at(located_creature.global_position, Vector3.UP)
		
		if attacking:
			elapsed_time_ATTACK += delta
			if elapsed_time_ATTACK > 1:
				located_creature.HEALTH -= calculate_damage()
				elapsed_time_ATTACK = 0.0
		
		if !buffLock:
			if located_creature.IS_DEAD:
				buffLock = true
				
				gui_HEALTH += 0.5
				ATK += 0.2
				DEF += 0.1
				LINEOFSIGHT_DIST += 0.5
				
				ENERGY = gui_ENERGY
				if HEALTH < gui_HEALTH:
					HEALTH += gui_HEALTH*0.25
					
				HEALTH = clampf(HEALTH,0,gui_HEALTH)
		else:
			elapsed_time_buffLock += delta
			if elapsed_time_buffLock > 7:
				buffLock = false
	
	rotation = Vector3(0,rotation.y,0)
	
	var current_location = global_position
	var next_location = get_node("NavigationAgent3D").get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = new_velocity
	move_and_slide()


func _on_flee_state_physics_processing(delta):
	$spriteIcon.texture = fleeIcon
	isWandering = false
	
	if !located_creature:
		$StateChart.send_event("wander")
	else:
		var escape_direction = global_position - located_creature.global_position
		escape_direction = escape_direction.normalized()
		
		var safe_distance = LINEOFSIGHT_DIST * 1.2 
		var new_target_position = global_position + escape_direction * safe_distance
		update_target_location(new_target_position)
		look_at(new_target_position, Vector3.UP)
	
	rotation = Vector3(0,rotation.y,0)
	
	var current_location = global_position
	var next_location = get_node("NavigationAgent3D").get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = new_velocity
	move_and_slide()


func _on_dead_state_processing(delta):
	$spriteIcon.texture = deadIcon
	
	elapsed_time_DEAD += delta
	
	isWandering = false
	
	$spriteIcon.texture = deadIcon
	
	creature_color.albedo_color = colour_dead
	$CollisionShape3D/MeshInstance3D.set_surface_override_material(0,creature_color)
	
	IS_DEAD = true
	update_target_location(Vector3.ZERO)
	
	if elapsed_time_DEAD > 5:
		queue_free()
	

# setting values before starting simulation
func _on_still_state_processing(delta):
	
	creature_color.albedo_color = colour_codes[gui_COLOUR]
	$CollisionShape3D/MeshInstance3D.set_surface_override_material(0,creature_color)
	
	HEALTH = gui_HEALTH
	ENERGY = gui_ENERGY
	SIZE = gui_SIZE
	SPEED = gui_SPEED
	MASS = gui_MASS
	ATK = gui_ATK
	DEF = gui_DEF
	LINEOFSIGHT_DIST = gui_LOS
	IS_CARNIVORE = gui_IS_CARNIVORE
	
	scale = Vector3(SIZE,SIZE,SIZE)

func _on_find_mate_state_physics_processing(delta):
	$spriteIcon.texture = findMateIcon
	
	isWandering = false
	
	if !located_creature:
		$StateChart.send_event("wander")
	else:
		update_target_location(located_creature.global_position)
		look_at(located_creature.global_position, Vector3.UP)
		
		if reproducing:
			$spriteIcon.texture = heartIcon
			
			
	
	
	rotation = Vector3(0,rotation.y,0)
	
	var current_location = global_position
	var next_location = get_node("NavigationAgent3D").get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	
	velocity = new_velocity
	move_and_slide()



