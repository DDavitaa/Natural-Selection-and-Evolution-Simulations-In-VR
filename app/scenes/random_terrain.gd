@tool
extends StaticBody3D

# export variables
@export_group("Terrain")
@export var size:int = 20
@export var yHeight:float = 5
@export var frequency:float = 0.1
@export var seed:int = 0

@export var update = false
@export var vertices_visibility = false
@export var generate_random = false

@export_group("Creature and Food")
@export var creature_amount:int = 3
@export var food_amount:int = 3

var countName:int = 0;

var random_generated = false
var size_set:int
var yHeight_set:float
var freq_set:float
var seed_set:int

var creature_amount_set:int
var creature_amount_check:int = 0
var food_amount_set:int
var food_amount_check:int = 0

var vertCount:int
var creature_scene
var food_scene

# nodes as variables
@onready var sim_world = $".."

@onready var terrain_mesh = $"NavigationRegion3D/terrain_mesh"
@onready var terrain_collision = $terrain_collision



# for shaders
var min_height:float = 0
var max_height:float = 1

var rng = RandomNumberGenerator.new()
var mdt = MeshDataTool.new()



func _ready():
	refresh_terrain(false)

func refresh_terrain(randomize:bool):
	for i in get_children():
		if "MeshInstance3D" in i.name:
			i.free()
		elif "creature" in i.name:
			i.free()
		elif "CharacterBody3D" in i.name:
			i.free()
		elif "Area3D" in i.name:
			i.free()
		elif "food" in i.name:
			i.free()
		

	generate_terrain(randomize)
	generate_creatures()
	generate_food()
	
func generate_creatures():
	creature_amount_set = creature_amount
	creature_amount_check = creature_amount_set
	
	if creature_scene == null:
		creature_scene = preload("res://scenes/creature.tscn")
	
	for i in creature_amount_set:
		gen_one_creature(creature_scene)
	
	
func gen_one_creature(creature_scene):
	var creature_instance = creature_scene.instantiate()
	
	add_child(creature_instance)
	
	var randVert:Vector3 = mdt.get_vertex(randi_range(0,vertCount))
	randVert.y += 0.2
	creature_instance.position = randVert
	
	var creature_scale = 0.2
	creature_instance.scale = Vector3(creature_scale,creature_scale,creature_scale)
	
	var randRot:Vector3 = Vector3(0,randf_range(0,360),0)
	creature_instance.rotation_degrees = randRot

func generate_food():
	food_amount_set = food_amount
	food_amount_check = food_amount_set
	
	if food_scene == null:
		food_scene = preload("res://scenes/food.tscn")
	
	for i in food_amount_set:
		gen_one_creature(food_scene)
	

func gen_one_food(food_scene):
	var food_instance = food_scene.instantiate()
	
	add_child(food_instance)
	
	var randVert:Vector3 = mdt.get_vertex(randi_range(0,vertCount))
	
	randVert.y += 0.1
	food_instance.position = randVert
	
	var food_scale = 0.1
	food_instance.scale = Vector3(food_scale,food_scale,food_scale)


func generate_terrain(randomize:bool):
	
	if randomize:
		size_set = rng.randi_range(30,80)
		yHeight_set = snappedf(rng.randf_range(1,5),0.01)
		freq_set = snappedf(rng.randf_range(0.05,0.15),0.01)
		seed_set = rng.randi_range(0,100)
	else:
		size_set = size
		yHeight_set = yHeight
		freq_set = frequency
		seed_set = seed
		
	
	# initializing variables
	var a_mesh:ArrayMesh
	var surftool = SurfaceTool.new()
	var n = FastNoiseLite.new()
	
	# noise settings
	n.noise_type = FastNoiseLite.TYPE_PERLIN
	n.frequency = freq_set
	n.seed = seed_set
	
	# creating vertices
	surftool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for z in range(size_set+1):
		for x in range(size_set+1):
			var y:float = n.get_noise_2d(x,z) * yHeight_set
			
			var uv = Vector2()
			uv.x = inverse_lerp(0,size_set,x)
			uv.y = inverse_lerp(0,size_set,z)
			surftool.set_uv(uv)
			
			if y < min_height and y != null:
				min_height = y
				
			if y > max_height and y != null:
				max_height = y
			
			surftool.add_vertex(Vector3(x,y,z))
			draw_sphere(Vector3(x,y,z))
	
	# adding indexes to vertices
	var vert = 0
	for z in size_set:
		for x in size_set:
			surftool.add_index(vert)
			surftool.add_index(vert+1)
			surftool.add_index(vert+1+size_set)
			surftool.add_index(vert+1+size_set)
			surftool.add_index(vert+1)
			surftool.add_index(vert+2+size_set)
			vert+=1
		vert+=1
		
		
	# mesh commited
	surftool.generate_normals()
	a_mesh = surftool.commit()
	
	# mesh data tool for number of vertices
	mdt.create_from_surface(a_mesh,0)
	vertCount = mdt.get_vertex_count()
	print(vertCount)
	
	for z in range(size_set+1):
		var y:float = -5
		surftool.add_vertex(Vector3(0,y,z))
		surftool.add_vertex(Vector3(size_set,y,z))
		draw_sphere(Vector3(0,y,z))
		draw_sphere(Vector3(size_set,y,z))
		
	for x in range(size_set+1):
		var y:float = -5
		surftool.add_vertex(Vector3(x,y,0))
		surftool.add_vertex(Vector3(x,y,size_set))
		draw_sphere(Vector3(x,y,0))
		draw_sphere(Vector3(x,y,size_set))
	
	# initiating variables with very specific formulae to connect the mesh together
	var halfSize:float = size_set/2.0
	
	var vertTopX1 = 4
	var vertBottomX1 = snappedf(vertCount/halfSize,1)
	
	var vertTopZ = size_set*2+2
	var vertBottomZ = 4
	
	var vertTopX2 = -1
	var vertBottomX2 = size_set * 2 + 3
	
	var vertTopZ2 = 2
	var vertBottomZ2 = size_set+1
	
	
	
	# manually make first four triangles as they cant be iterated through on x axis side 1
	surftool.add_index(0)
	surftool.add_index(vertCount)
	surftool.add_index(1)
	
	surftool.add_index(1)
	surftool.add_index(vertCount)
	surftool.add_index(vertCount+vertBottomX1)
	
	surftool.add_index(1)
	surftool.add_index(vertCount+vertBottomX1)
	surftool.add_index(4)
	
	surftool.add_index(4)
	surftool.add_index(vertCount+vertBottomX1)
	surftool.add_index(vertCount+vertBottomX1+2)
	
	vertBottomX1 += 2
	
	# manually make first four triangles as they cant be iterated through on z axis side 1
	surftool.add_index(2)
	surftool.add_index(vertCount+0)
	surftool.add_index(0)
	
	surftool.add_index(2)
	surftool.add_index(vertCount+2)
	surftool.add_index(vertCount)
	
	surftool.add_index(vertTopZ)
	surftool.add_index(vertCount+2)
	surftool.add_index(2)
	
	surftool.add_index(vertTopZ)
	surftool.add_index(vertCount+4)
	surftool.add_index(vertCount+2)
	
	# manually make first four triangles as they cant be iterated through on x axis side 2
	surftool.add_index(vertCount+vertTopX2)
	surftool.add_index(vertCount+size_set*2+vertBottomX2)
	surftool.add_index(vertCount+vertTopX2-1)
	surftool.add_index(vertCount+vertTopX2-1)
	surftool.add_index(vertCount+size_set*2+vertBottomX2)
	surftool.add_index(vertCount+size_set*2+vertBottomX2-2)
	vertTopX2 -= 1
	vertBottomX2 -= 2
	surftool.add_index(vertCount+vertTopX2)
	surftool.add_index(vertCount+size_set*2+vertBottomX2)
	surftool.add_index(vertCount+vertTopX2-1)
	surftool.add_index(vertCount+vertTopX2-1)
	surftool.add_index(vertCount+size_set*2+vertBottomX2)
	surftool.add_index(vertCount+size_set*2+vertBottomX2-2)
	vertTopX2 -= 1
	vertBottomX2 -= 2
	
	# manually make first four triangles as they cant be iterated through on z axis side 2
	surftool.add_index(vertCount-1) #top
	surftool.add_index(vertCount+size_set+vertBottomZ2-2) #bottom
	surftool.add_index(vertCount+size_set+vertBottomZ2) #bottom
	
	surftool.add_index(vertCount-1) #top
	surftool.add_index(vertCount-size_set-2) #top
	surftool.add_index(vertCount+size_set+vertBottomZ2-2) #bottom
	
	vertBottomZ2 -= 2
	
	surftool.add_index(vertCount-size_set-2)
	surftool.add_index(vertCount+size_set+vertBottomZ2-2)
	surftool.add_index(vertCount+size_set+vertBottomZ2)
	
	surftool.add_index(vertCount-size_set-2)
	surftool.add_index(vertCount-size_set*2-3)
	surftool.add_index(vertCount+size_set+vertBottomZ2-2)
	
	vertBottomZ2 -= 2
	
	for i in size_set-2:
		#x side 1
		surftool.add_index(vertTopX1)
		surftool.add_index(vertCount+vertBottomX1)
		surftool.add_index(vertTopX1+2)
		
		surftool.add_index(vertTopX1+2)
		surftool.add_index(vertCount+vertBottomX1)
		surftool.add_index(vertCount+vertBottomX1+2)
		
		vertTopX1 +=2
		vertBottomX1 +=2
		
		#z side 1
		surftool.add_index(vertTopZ+size_set+1)
		surftool.add_index(vertCount+vertBottomZ)
		surftool.add_index(vertTopZ)

		surftool.add_index(vertTopZ+size_set+1)
		surftool.add_index(vertCount+vertBottomZ+2)
		surftool.add_index(vertCount+vertBottomZ)
		
		vertTopZ += size_set+1
		vertBottomZ += 2
		
		#x side 2
		surftool.add_index(vertCount+vertTopX2)
		surftool.add_index(vertCount+size_set*2+vertBottomX2)
		surftool.add_index(vertCount+vertTopX2-1)
		
		surftool.add_index(vertCount+vertTopX2-1)
		surftool.add_index(vertCount+size_set*2+vertBottomX2)
		surftool.add_index(vertCount+size_set*2+vertBottomX2-2)
		
		vertTopX2 -= 1
		vertBottomX2 -= 2
		
		#z side 2
		surftool.add_index(vertCount-size_set*vertTopZ2-vertTopZ2-1)
		surftool.add_index(vertCount+size_set+vertBottomZ2-2)
		surftool.add_index(vertCount+size_set+vertBottomZ2)
		
		surftool.add_index(vertCount-size_set*vertTopZ2-vertTopZ2-1)
		surftool.add_index(vertCount-size_set*(vertTopZ2+1)-vertTopZ2-2)
		surftool.add_index(vertCount+size_set+vertBottomZ2-2)
		
		if i < size_set-4:
			vertTopZ2 += 1
			vertBottomZ2 -= 2
			
	
	vertTopZ2 += 1
	vertBottomZ2 -= 2
	surftool.add_index(vertCount-size_set*vertTopZ2-vertTopZ2-1)
	surftool.add_index(vertCount+size_set+vertBottomZ2-2)
	surftool.add_index(vertCount+size_set+vertBottomZ2)
	
	surftool.add_index(vertCount-size_set*vertTopZ2-vertTopZ2-1)
	surftool.add_index(size_set*2)
	surftool.add_index(vertCount+size_set+vertBottomZ2-2)
	
	a_mesh = surftool.commit()
	
	terrain_mesh.mesh = a_mesh
	terrain_collision.shape = a_mesh.create_trimesh_shape()
	
	update_shader()
	
	# align center of mesh to origin
	var aabb:AABB = surftool.get_aabb()
	position = Vector3(0,yHeight_set,0) - aabb.get_center()
	
	get_node("../ProtonScatter/ScatterShape").scale = Vector3(size_set-1,1,size_set-1)
	get_node("NavigationRegion3D").bake_navigation_mesh()
	

func update_shader():
	var mat = terrain_mesh.get_active_material(0)
	mat.set_shader_parameter("min_grass_height",min_height)
	mat.set_shader_parameter("max_gravel_height",max_height)

func draw_sphere(pos:Vector3):
	var ins = MeshInstance3D.new()
	add_child(ins)
	ins.position = pos
	var sphere = SphereMesh.new()
	sphere.radius = 0.1
	sphere.height = 0.2
	ins.mesh = sphere

func _process(delta):
	if update:
		refresh_terrain(false)
		update = false
		random_generated = false
	
	if generate_random:
		refresh_terrain(true)
		generate_random = false
		random_generated = true
		
	if !random_generated:
		if size != size_set || yHeight != yHeight_set || frequency != freq_set || seed != seed_set:
			refresh_terrain(false)
		
	if vertices_visibility == false:
		var j = 1
		for i in get_children():
			if("MeshInstance3D" in i.name):
				i.visible = false
	else:
		var j = 1
		for i in get_children():
			if("MeshInstance3D" in i.name):
				i.visible = true
	
	position.y = yHeight_set - yHeight_set/2
			
	if food_amount_check < food_amount_set:
		gen_one_food(food_scene)
		food_amount_check += 1



