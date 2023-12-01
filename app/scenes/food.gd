extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var randPos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "creature":
		print("yes")
