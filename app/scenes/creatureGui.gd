extends Control

@onready var creature = get_node("../../../")

@onready var display_id = $"MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/PanelContainer/HSplitContainer2/MarginContainer2/Label2"
@onready var display_colour = $"MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HSplitContainer/VBoxContainer/cgui_colour/HSplitContainer/Label2"
@onready var display_health = $"MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HSplitContainer/VBoxContainer/cgui_health/HSplitContainer/Label2"
@onready var display_energy = $"MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HSplitContainer/VBoxContainer/cgui_energy/HSplitContainer/Label2"
@onready var display_size = $"MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HSplitContainer/VBoxContainer/cgui_size/HSplitContainer/Label2"
@onready var display_speed = $"MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HSplitContainer/VBoxContainer/cgui_speed/HSplitContainer/Label2"
@onready var display_mass = $"MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HSplitContainer/VBoxContainer/cgui_mass/HSplitContainer/Label2"
@onready var display_atk = $"MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HSplitContainer/VBoxContainer2/cgui_atk/HSplitContainer/Label2"
@onready var display_def = $"MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HSplitContainer/VBoxContainer2/cgui_def/HSplitContainer/Label2"
@onready var display_los = $"MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HSplitContainer/VBoxContainer2/cgui_los/HSplitContainer/Label2"
@onready var display_diet = $"MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/HSplitContainer/VBoxContainer2/cgui_diet/HSplitContainer/Label2"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	display_id.text = str(creature.creature_id)
	display_colour.text = creature.colour_names[creature.gui_COLOUR]
	display_health.text = str(creature.HEALTH) + " / " + str(creature.gui_HEALTH)
	display_energy.text = str(creature.ENERGY) + " / " + str(creature.gui_ENERGY)
	display_size.text = str(creature.SIZE)
	display_speed.text = str(creature.SPEED)
	display_mass.text = str(creature.MASS)
	display_atk.text = str(creature.ATK)
	display_def.text = str(creature.DEF)
	display_los.text = str(creature.LINEOFSIGHT_DIST)
	
	if creature.IS_CARNIVORE:
		display_diet.text = "Carnivore"
	else:
		display_diet.text = "Herbivore"
	


func _on_kill_pressed():
	creature.get_node("StateChart").send_event("dead")
