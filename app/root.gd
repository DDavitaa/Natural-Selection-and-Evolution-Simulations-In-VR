extends Node3D

var xr_interface: XRInterface

var is_using_xr:bool
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialised successfully")

		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
		is_using_xr = true
	else:
		print("OpenXR not initialized, please check if your headset is connected")
		is_using_xr = false
 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
