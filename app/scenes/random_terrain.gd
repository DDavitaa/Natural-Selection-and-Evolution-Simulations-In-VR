@tool
extends MeshInstance3D

@export var xSize = 20
@export var zSize = 20

@export var update = false
@export var clear_vert_vis = false

func _ready():
	generate_terrain()
	

func generate_terrain():
	var a_mesh:ArrayMesh
	var  surftool = SurfaceTool.new()
	
	surftool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for z in range(zSize+1):
		for x in range(xSize+1):
			var y = 0
			
			surftool.add_vertex(Vector3(x,y,z))
			draw_sphere(Vector3(x,y,z))
	
	a_mesh = surftool.commit()
	mesh = a_mesh
	
	
func draw_sphere(pos:Vector3):
	var ins = MeshInstance3D.new()
	add_child(ins)
	ins.position = pos
	var sphere = SphereMesh.new()
	sphere.radius = 0.1
	sphere.height = 0.2
	ins.mesh = sphere

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if update:
		generate_terrain()
		update = false
		
	if clear_vert_vis:
		for i in get_children():
			i.free()
