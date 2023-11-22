@tool
extends StaticBody3D

@export var xSize = 20
@export var zSize = 20
@export var yHeight:float = 5
@export var seed:int = 0

@export var update = false
@export var vertices_visibility = false



func _ready():
	generate_terrain()
	

func generate_terrain():
	var a_mesh:ArrayMesh
	var surftool = SurfaceTool.new()
	var n = FastNoiseLite.new()
	
	n.noise_type = FastNoiseLite.TYPE_PERLIN
	n.frequency = 0.1
	n.seed = seed
	
	surftool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for z in range(zSize+1):
		for x in range(xSize+1):
			var y = n.get_noise_2d(x,z) * yHeight
			
			surftool.add_vertex(Vector3(x,y,z))
			draw_sphere(Vector3(x,y,z))
	
	surftool.add_index(0)
	surftool.add_index(1)
	surftool.add_index(xSize+1)
	
	var vert = 0
	for z in zSize:
		for x in xSize:
			surftool.add_index(vert)
			surftool.add_index(vert+1)
			surftool.add_index(vert+1+xSize)
			surftool.add_index(vert+1+xSize)
			surftool.add_index(vert+1)
			surftool.add_index(vert+2+xSize)
			vert+=1
		vert+=1
		
	surftool.generate_normals()
	
	a_mesh = surftool.commit()
	
	var terrain_mesh = MeshInstance3D.new()
	add_child(terrain_mesh)
	terrain_mesh.mesh = a_mesh
	
	var terrain_collision = CollisionShape3D.new()
	add_child(terrain_collision)
	terrain_collision.shape = a_mesh.create_trimesh_shape()
	

func draw_sphere(pos:Vector3):
	var ins = MeshInstance3D.new()
	add_child(ins)
	ins.name = "vert"
	ins.position = pos
	var sphere = SphereMesh.new()
	sphere.radius = 0.1
	sphere.height = 0.2
	ins.mesh = sphere
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if update:
		for i in get_children():
			i.free()
		generate_terrain()
		update = false
		
	if (vertices_visibility == false):
		var j = 1
		for i in get_children():
			if(i.name == "vert"):
				i.visible = false
				
			elif(i.name == "vert" + str(j)) :
				i.visible = false
			j+=1
	else:
		var j = 1
		for i in get_children():
			if(i.name == "vert"):
				i.visible = true
				
			elif(i.name == "vert" + str(j)):
				i.visible = true
			j+=1
		
