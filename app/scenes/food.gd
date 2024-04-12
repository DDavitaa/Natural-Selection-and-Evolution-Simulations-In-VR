extends Area3D

@onready var terrain = get_node("../")
@onready var food = $"CollisionShape3D/MeshInstance3D"

var health_factor:float = 0.25
var buff_HEALTH:float = 0.5
var buff_ATK:float = 0.2
var buff_DEF:float = 0.1
var buff_LOS:float = 0.5
var poisonousChance:float = 0.2

var isPoisonous = false
var rng = RandomNumberGenerator.new()
var rng_check = false


func _ready():
	pass
	

func _process(delta):
	if rng_check:
		isPoisonous = rng.randf_range(0,1) <= poisonousChance
	
		# if poisonous, food is purple, if not then green
		var poisonColour = StandardMaterial3D.new()
		poisonColour.albedo_color = Color(0.5,0,0.65)
		
		if isPoisonous:
			food.set_surface_override_material(0,poisonColour)
		
		rng_check = false

func _on_body_entered(body):
	if body.is_in_group("creature") and body.ENERGY < body.gui_ENERGY*0.5 and !body.IS_CARNIVORE:
		
		body.located_plant = Vector3.ZERO
		body.plantlock = false
		
		if !isPoisonous:
			# buffs
			body.gui_HEALTH += buff_HEALTH
			body.ATK += buff_ATK
			body.DEF += buff_DEF
			body.LINEOFSIGHT_DIST += buff_LOS
			
			# replenishments
			body.ENERGY = body.gui_ENERGY
			
			if body.HEALTH < body.gui_HEALTH:
				body.HEALTH += body.gui_HEALTH*health_factor
			
			body.HEALTH = clampf(body.HEALTH,0,body.gui_HEALTH)
			
			
			
		else: # debuff if poisonous
			
			# replenish quarter of energy
			body.ENERGY += body.gui_ENERGY * 0.25
			body.HEALTH -= body.gui_HEALTH * 0.1
			
			body.gui_HEALTH -= buff_HEALTH
			body.ATK -= buff_ATK
			body.DEF -= buff_DEF
			body.LINEOFSIGHT_DIST -= buff_LOS
		
		body.get_node("StateChart").send_event("lookforfood_wander")
		
		terrain.food_amount_check -= 1
		
		queue_free()
