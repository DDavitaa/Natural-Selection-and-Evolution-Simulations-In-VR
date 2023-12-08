extends Area3D

@onready var terrain = get_node("../")

var sound = AudioStreamPlayer3D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(sound)
	sound.volume_db = -15.0
	sound.stream = load("res://audio/pop-up-something-160353.mp3")
	sound.playing = true
	sound.emission_angle_enabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("creatures"):
		
		sound.play()
		body.get_node("CollisionShape3D").scale += Vector3(0.3,0.3,0.3)
		body.SPEED += 0.1
		terrain.food_amount_check -= 1
		
		queue_free()
