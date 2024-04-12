# https://github.com/DDavitaa/Natural-Selection-and-Evolution-Simulations-In-VR

extends Node3D

var is_using_xr:bool

var xr_interface: XRInterface

func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialised successfully")

		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		get_viewport().use_xr = true
		is_using_xr = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")
		is_using_xr = false
 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
