extends Control

# CREATURES
@onready var chosen_colour = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Creatures/Vbox_Creatures/Margin_Colour/HSplitContainer/OptionButton"
@onready var chosen_health = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Creatures/Vbox_Creatures/Margin_Health/HSplitContainer/HSplitContainer/HSlider"
@onready var chosen_energy = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Creatures/Vbox_Creatures/Margin_Energy/HSplitContainer/HSplitContainer/HSlider"
@onready var chosen_size = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Creatures/Vbox_Creatures/Margin_Size/HSplitContainer/HSplitContainer/HSlider"
@onready var chosen_speed = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Creatures/Vbox_Creatures/Margin_Speed/HSplitContainer/HSplitContainer/HSlider"
@onready var chosen_mass = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Creatures/Vbox_Creatures/Margin_Mass/HSplitContainer/HSplitContainer/HSlider"
@onready var chosen_atk = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Creatures/Vbox_Creatures/Margin_Attack/HSplitContainer/HSplitContainer/HSlider"
@onready var chosen_def = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Creatures/Vbox_Creatures/Margin_Defence/HSplitContainer/HSplitContainer/HSlider"
@onready var chosen_los = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Creatures/Vbox_Creatures/Margin_LOSDist/HSplitContainer/HSplitContainer/HSlider"
@onready var chosen_diet = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Creatures/Vbox_Creatures/Margin_Diet/HSplitContainer/OptionButton"

@onready var chosen_noCreatures = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Creatures/Vbox_Creatures/PanelContainer/VBoxContainer/Margin_AddCreatures/HSplitContainer/HSplitContainer/SpinBox"
var countCreatures

@onready var pre1btn = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Creatures/Vbox_Creatures/PanelContainer/VBoxContainer/Margin_Presets/HSplitContainer/HBoxContainer/pre1"
@onready var pre2btn = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Creatures/Vbox_Creatures/PanelContainer/VBoxContainer/Margin_Presets/HSplitContainer/HBoxContainer/pre2"
@onready var pre3btn = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Creatures/Vbox_Creatures/PanelContainer/VBoxContainer/Margin_Presets/HSplitContainer/HBoxContainer/pre3"
@onready var pre4btn = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Creatures/Vbox_Creatures/PanelContainer/VBoxContainer/Margin_Presets/HSplitContainer/HBoxContainer/pre4"

@onready var pausebtn = $"VBoxContainer/PanelContainer/MarginContainer/HSplitContainer/pause"
@onready var playbtn = $"VBoxContainer/PanelContainer/MarginContainer/HSplitContainer/HSplitContainer/play"
@onready var ffbtn = $"VBoxContainer/PanelContainer/MarginContainer/HSplitContainer/HSplitContainer/fastforward"

# colorID,health,energy,size,speed,mass,atk,def,LineOfSightDistance,Diet
var preset1 = [0,10,200,0.2,1,80,4,4,5,0]
var preset2 = [1,15,300,0.1,0.8,100,3,6,4,1]
var preset3 = [0,10,200,0.2,1,80,4,4,5,0]
var preset4 = [0,10,200,0.2,1,80,4,4,5,0]

var selectedPreset = 1
var selectedColour = Color(0.03,0.3,0.6,1)
var deselectedColour = Color(0.1,0.1,0.1,0.6)

# ENVIRONMENT
@onready var chosen_terrainSize = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Environment/Margin_Size/HSplit_Size/HSplit_Height/HSlider"
@onready var chosen_terrainHeight = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Environment/Margin_Height/HSplit_Height/HSplit_Height/HSlider"
@onready var chosen_terrainFreq = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Environment/Margin_Freq/HSplit_Freq/HSplitContainer/HSlider"
@onready var chosen_terrainSeed = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Environment/Margin_Seed/HSplit_Seed/SpinBox"

@onready var terrain = get_node("../../../../simulation_origin/terrain_staticBody")

# size,height,frequency,seed
var default_terrain = [30,2,0.08,0]


# FOOD
@onready var chosen_foodHealthFactor = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Food/Margin_HFactor/HSplit/SpinBox"
@onready var chosen_foodbuffHealth = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Food/Margin_BuffHealth/HSplit/SpinBox"
@onready var chosen_foodbuffAtk = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Food/Margin_BuffAtk/HSplit/SpinBox"
@onready var chosen_foodbuffDef = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Food/Margin_BuffDef/HSplit/SpinBox"
@onready var chosen_foodbuffLos = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Food/Margin_BuffLos/HSplit/SpinBox"
@onready var chosen_foodPoisonCh = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Food/Margin_BuffPoison/HSplit/SpinBox"
@onready var chosen_foodAmount = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Food/PanelContainer/VBoxContainer/Margin_AddFood/HSplitContainer/HSplitContainer/SpinBox"

# healthfactor,buffhealth,buffatk,buffdef,bufflos,buffpoisonch,foodamount
var default_food = [25,0.2,0.2,0.1,0.5,20,10]


# SETTINGS
@onready var musicAudio = get_node("../../../../env/Audio_music")
@onready var chosen_volume = $"VBoxContainer/MarginContainer/VBoxContainer/TAB_CONTAINER/Settings/Margin/HSplit/HSplit/HSlider"
var playsim_check = false


# bring the generation of creatures here!!!!!!!!!!!!!!!!!!!!!!!!


func _ready():
	pass	
	
func _process(delta):
	pass

# CREATURES

func _on_addbtn_pressed():	
	terrain.generate_creatures(chosen_noCreatures.value,chosen_colour.selected,chosen_health.value,chosen_energy.value,chosen_size.value,chosen_speed.value,chosen_mass.value,chosen_atk.value,chosen_def.value,chosen_los.value,chosen_diet.selected)
	

func _on_clearbtn_pressed():
	for i in terrain.get_children():
		if "creature" in i.name:
			i.queue_free()
		elif "CharacterBody3D" in i.name:
			i.queue_free()
	
	terrain.set_creature_id = 0
	pass


func _on_pre_1_pressed():
	selectedPreset = 1
	
	pre1btn.get_theme_stylebox("normal").bg_color = selectedColour
	pre2btn.get_theme_stylebox("normal").bg_color = deselectedColour
	pre3btn.get_theme_stylebox("normal").bg_color = deselectedColour
	pre4btn.get_theme_stylebox("normal").bg_color = deselectedColour
	
	# if preset1 button is pressed, load the values
	chosen_colour.selected = preset1[0]
	chosen_health.value = preset1[1]
	chosen_energy.value = preset1[2]
	chosen_size.value = preset1[3]
	chosen_speed.value = preset1[4]
	chosen_mass.value = preset1[5]
	chosen_atk.value = preset1[6]
	chosen_def.value = preset1[7]
	chosen_los.value = preset1[8]
	chosen_diet.selected = preset1[9]


func _on_pre_2_pressed():
	selectedPreset = 2
	
	pre1btn.get_theme_stylebox("normal").bg_color = deselectedColour
	pre2btn.get_theme_stylebox("normal").bg_color = selectedColour
	pre3btn.get_theme_stylebox("normal").bg_color = deselectedColour
	pre4btn.get_theme_stylebox("normal").bg_color = deselectedColour
	
	# if preset2 button is pressed, load the values
	chosen_colour.selected = preset2[0]
	chosen_health.value = preset2[1]
	chosen_energy.value = preset2[2]
	chosen_size.value = preset2[3]
	chosen_speed.value = preset2[4]
	chosen_mass.value = preset2[5]
	chosen_atk.value = preset2[6]
	chosen_def.value = preset2[7]
	chosen_los.value = preset2[8]
	chosen_diet.selected = preset2[9]


func _on_pre_3_pressed():
	selectedPreset = 3
	
	pre1btn.get_theme_stylebox("normal").bg_color = deselectedColour
	pre2btn.get_theme_stylebox("normal").bg_color = deselectedColour
	pre3btn.get_theme_stylebox("normal").bg_color = selectedColour
	pre4btn.get_theme_stylebox("normal").bg_color = deselectedColour
	
	# if preset2 button is pressed, load the values
	chosen_colour.selected = preset3[0]
	chosen_health.value = preset3[1]
	chosen_energy.value = preset3[2]
	chosen_size.value = preset3[3]
	chosen_speed.value = preset3[4]
	chosen_mass.value = preset3[5]
	chosen_atk.value = preset3[6]
	chosen_def.value = preset3[7]
	chosen_los.value = preset3[8]
	chosen_diet.selected = preset3[9]


func _on_pre_4_pressed():
	selectedPreset = 4
	
	pre1btn.get_theme_stylebox("normal").bg_color = deselectedColour
	pre2btn.get_theme_stylebox("normal").bg_color = deselectedColour
	pre3btn.get_theme_stylebox("normal").bg_color = deselectedColour
	pre4btn.get_theme_stylebox("normal").bg_color = selectedColour
	
	# if preset2 button is pressed, load the values
	chosen_colour.selected = preset4[0]
	chosen_health.value = preset4[1]
	chosen_energy.value = preset4[2]
	chosen_size.value = preset4[3]
	chosen_speed.value = preset4[4]
	chosen_mass.value = preset4[5]
	chosen_atk.value = preset4[6]
	chosen_def.value = preset4[7]
	chosen_los.value = preset4[8]
	chosen_diet.selected = preset4[9]


func _on_savetbtn_pressed():
	if selectedPreset == 1:
		preset1[0] = chosen_colour.selected
		preset1[1] = chosen_health.value
		preset1[2] = chosen_energy.value
		preset1[3] = chosen_size.value
		preset1[4] = chosen_speed.value
		preset1[5] = chosen_mass.value
		preset1[6] = chosen_atk.value
		preset1[7] = chosen_def.value
		preset1[8] = chosen_los.value
		preset1[9] = chosen_diet.selected
	elif selectedPreset == 2:
		preset2[0] = chosen_colour.selected
		preset2[1] = chosen_health.value
		preset2[2] = chosen_energy.value
		preset2[3] = chosen_size.value
		preset2[4] = chosen_speed.value
		preset2[5] = chosen_mass.value
		preset2[6] = chosen_atk.value
		preset2[7] = chosen_def.value
		preset2[8] = chosen_los.value
		preset2[9] = chosen_diet.selected
	elif selectedPreset == 3:
		preset3[0] = chosen_colour.selected
		preset3[1] = chosen_health.value
		preset3[2] = chosen_energy.value
		preset3[3] = chosen_size.value
		preset3[4] = chosen_speed.value
		preset3[5] = chosen_mass.value
		preset3[6] = chosen_atk.value
		preset3[7] = chosen_def.value
		preset3[8] = chosen_los.value
		preset3[9] = chosen_diet.selected
	elif selectedPreset == 4:
		preset4[0] = chosen_colour.selected
		preset4[1] = chosen_health.value
		preset4[2] = chosen_energy.value
		preset4[3] = chosen_size.value
		preset4[4] = chosen_speed.value
		preset4[5] = chosen_mass.value
		preset4[6] = chosen_atk.value
		preset4[7] = chosen_def.value
		preset4[8] = chosen_los.value
		preset4[9] = chosen_diet.selected
		


func _on_defaultbtn_pressed():
	# sets selected preset back to its own respective default preset
	if selectedPreset == 1:
		chosen_colour.selected = preset1[0]
		chosen_health.value = preset1[1]
		chosen_energy.value = preset1[2]
		chosen_size.value = preset1[3]
		chosen_speed.value = preset1[4]
		chosen_mass.value = preset1[5]
		chosen_atk.value = preset1[6]
		chosen_def.value = preset1[7]
		chosen_los.value = preset1[8]
		chosen_diet.selected = preset1[9]
	elif selectedPreset == 2:
		chosen_colour.selected = preset2[0]
		chosen_health.value = preset2[1]
		chosen_energy.value = preset2[2]
		chosen_size.value = preset2[3]
		chosen_speed.value = preset2[4]
		chosen_mass.value = preset2[5]
		chosen_atk.value = preset2[6]
		chosen_def.value = preset2[7]
		chosen_los.value = preset2[8]
		chosen_diet.selected = preset2[9]
	elif selectedPreset == 3:
		chosen_colour.selected = preset3[0]
		chosen_health.value = preset3[1]
		chosen_energy.value = preset3[2]
		chosen_size.value = preset3[3]
		chosen_speed.value = preset3[4]
		chosen_mass.value = preset3[5]
		chosen_atk.value = preset3[6]
		chosen_def.value = preset3[7]
		chosen_los.value = preset3[8]
		chosen_diet.selected = preset3[9]
	elif selectedPreset == 4:
		chosen_colour.selected = preset4[0]
		chosen_health.value = preset4[1]
		chosen_energy.value = preset4[2]
		chosen_size.value = preset4[3]
		chosen_speed.value = preset4[4]
		chosen_mass.value = preset4[5]
		chosen_atk.value = preset4[6]
		chosen_def.value = preset4[7]
		chosen_los.value = preset4[8]
		chosen_diet.selected = preset4[9]
	

func _on_pause_pressed():
	pausebtn.get_theme_stylebox("normal").bg_color = selectedColour
	playbtn.get_theme_stylebox("normal").bg_color = deselectedColour
	ffbtn.get_theme_stylebox("normal").bg_color = deselectedColour
	
	Engine.time_scale = 1
	get_tree().paused = true
	

func _on_play_pressed():
	pausebtn.get_theme_stylebox("normal").bg_color = deselectedColour
	playbtn.get_theme_stylebox("normal").bg_color = selectedColour
	ffbtn.get_theme_stylebox("normal").bg_color = deselectedColour
	
	Engine.time_scale = 1
	get_tree().paused = false
	

func _on_fastforward_pressed():
	pausebtn.get_theme_stylebox("normal").bg_color = deselectedColour
	playbtn.get_theme_stylebox("normal").bg_color = deselectedColour
	ffbtn.get_theme_stylebox("normal").bg_color = selectedColour
	
	get_tree().paused = false
	Engine.time_scale = 4


# ENVIRONMENT

func _on_update_pressed():
	terrain.t_size = chosen_terrainSize.value
	terrain.t_yHeight = chosen_terrainHeight.value
	terrain.t_frequency = chosen_terrainFreq.value
	terrain.t_seed = chosen_terrainSeed.value
	
	terrain.refresh_terrain(false)
	

func _on_default_pressed():
	chosen_terrainSize.value = default_terrain[0]
	chosen_terrainHeight.value = default_terrain[1]
	chosen_terrainFreq.value = default_terrain[2]
	chosen_terrainSeed.value = default_terrain[3]
	
# FOOD
func _on_addbtnfood_pressed():
	terrain.generate_food(chosen_foodAmount.value,chosen_foodHealthFactor.value,chosen_foodbuffHealth.value,chosen_foodbuffAtk.value,chosen_foodbuffDef.value,chosen_foodbuffLos.value,chosen_foodPoisonCh.value)

func _on_clearbtnfood_pressed():
	for i in terrain.get_children():
		if "Area3D" in i.name:
			i.queue_free()
		elif "food" in i.name:
			i.queue_free()

func _on_defaultbtnfood_pressed():
	chosen_foodHealthFactor.value = default_food[0]
	chosen_foodbuffHealth.value = default_food[1]
	chosen_foodbuffAtk.value = default_food[2]
	chosen_foodbuffDef.value = default_food[3]
	chosen_foodbuffLos.value = default_food[4]
	chosen_foodPoisonCh.value = default_food[5]
	chosen_foodAmount.value = default_food[6]

# SETTINGS
func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	

func _on_playsim_pressed():
	if !playsim_check:
		for i in terrain.get_children():
			if "creature" in i.name:
				i.get_node("StateChart").send_event("still_to_wander")
			elif "CharacterBody3D" in i.name:
				i.get_node("StateChart").send_event("still_to_wander")
		playsim_check = true
		

func _on_resetsim_pressed():
	for i in terrain.get_children():
		if "creature" in i.name:
			i.queue_free()
		elif "CharacterBody3D" in i.name:
			i.queue_free()
		elif "Area3D" in i.name:
			i.queue_free()
		elif "food" in i.name:
			i.queue_free()
	
	playsim_check = false
	terrain.set_creature_id = 0


func _on_exit_pressed():
	get_tree().quit()
