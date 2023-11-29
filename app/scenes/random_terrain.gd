@tool
extends StaticBody3D

@export var xSize:int = 20
var xSize_set:int

@export var zSize:int = 20
var zSize_set:int

@export var yHeight:float = 5
var yHeight_set:float

@export var frequency:float = 0.1
var freq_set:float

@export var seed:int = 0
var seed_set:int

@export var delete_terrain = false
@export var update = false
@export var vertices_visibility = false
@export var generate_random = false
var random_generated = false

@onready var terrain_mesh = $terrain_mesh
@onready var terrain_collision = $terrain_collision

var min_height:float = 0
var max_height:float = 1




func _ready():
	generate_terrain(false)
	

func generate_terrain(randomize:bool):
	
	if randomize:
		var rng = RandomNumberGenerator.new()
		var rand_size = rng.randi_range(30,80)
		
		xSize_set = rand_size
		zSize_set = rand_size
		yHeight_set = snappedf(rng.randf_range(1,5),0.01)
		freq_set = snappedf(rng.randf_range(0.05,0.15),0.01)
		seed_set = rng.randi_range(0,100)
		
	else:
		xSize_set = xSize
		zSize_set = zSize
		yHeight_set = yHeight
		freq_set = frequency
		seed_set = seed
	
	var a_mesh:ArrayMesh
	var surftool = SurfaceTool.new()
	var n = FastNoiseLite.new()
	
	n.noise_type = FastNoiseLite.TYPE_PERLIN
	n.frequency = freq_set
	
	n.seed = seed_set
	
	surftool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for z in range(zSize_set+1):
		for x in range(xSize_set+1):
			var y:float = n.get_noise_2d(x,z) * yHeight_set
			
			var uv = Vector2()
			uv.x = inverse_lerp(0,xSize_set,x)
			uv.y = inverse_lerp(0,zSize_set,z)
			surftool.set_uv(uv)
			
			if y < min_height and y != null:
				min_height = y
				
			if y > max_height and y != null:
				max_height = y
			
			surftool.add_vertex(Vector3(x,y,z))
			draw_sphere(Vector3(x,y,z))
			
	
	var vert = 0
	for z in zSize_set:
		for x in xSize_set:
			surftool.add_index(vert)
			surftool.add_index(vert+1)
			surftool.add_index(vert+1+xSize_set)
			surftool.add_index(vert+1+xSize_set)
			surftool.add_index(vert+1)
			surftool.add_index(vert+2+xSize_set)
			vert+=1
		vert+=1
		
	surftool.generate_normals()
	a_mesh = surftool.commit()
	
	terrain_mesh.mesh = a_mesh
	terrain_collision.shape = a_mesh.create_trimesh_shape()
	
	update_shader()
	
	var aabb:AABB = surftool.get_aabb()
	
	position = Vector3(0,yHeight_set,0) - aabb.get_center()
	
	print(draw_sphere(aabb.get_center()))
	

func update_shader():
	var mat = terrain_mesh.get_active_material(0)
	mat.set_shader_parameter("min_height",min_height)
	mat.set_shader_parameter("max_height",max_height)

func draw_sphere(pos:Vector3):
	var ins = MeshInstance3D.new()
	add_child(ins)
	ins.position = pos
	var sphere = SphereMesh.new()
	sphere.radius = 0.1
	sphere.height = 0.2
	ins.mesh = sphere
	

func refresh_terrain(randomize:bool):
	for i in get_children():
		if "MeshInstance3D" in i.name:
			i.free()
			
	generate_terrain(randomize)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if delete_terrain:
		for i in get_children():
			if "MeshInstance3D" in i.name:
				i.free()
		delete_terrain = false
	
	if update:
		refresh_terrain(false)
		update = false
		random_generated = false
	
		
	if generate_random:
		refresh_terrain(true)
		generate_random = false
		random_generated = true
		
	if !random_generated:
		if xSize != xSize_set || zSize != zSize_set || yHeight != yHeight_set || frequency != freq_set ||seed != seed_set:
			refresh_terrain(false)
		
	if (vertices_visibility == false):
		var j = 1
		for i in get_children():
			if("MeshInstance3D" in i.name):
				i.visible = false
	else:
		var j = 1
		for i in get_children():
			if("MeshInstance3D" in i.name):
				i.visible = true
				
	#########TODO: adjust pos of staticbody to keep origin at center
	
	position.y = yHeight_set
	
	
	
