extends Node
#class_name Backpack


#@export var font_size = 16
@export var vine_souls = 0
@export var pine_souls = 0
@export var has_deer_soul = false
@export var has_bear_soul = false

@onready var vine_label = $Control/MarginContainer/HBoxContainer/VBoxContainer2/CenterContainer2/VineLabel
@onready var pine_label = $Control/MarginContainer/HBoxContainer/VBoxContainer/CenterContainer2/PineLabel

func _ready():
	#vine_label.add_theme_font_size_override()
	pass

func _process(delta):
	if has_deer_soul == true:
		$Control/MarginContainer/HBoxContainer/VBoxContainer3.visible = true
	else:
		$Control/MarginContainer/HBoxContainer/VBoxContainer3.visible = false
	if has_deer_soul == true:
		$Control/MarginContainer/HBoxContainer/VBoxContainer4.visible = true
	else:
		$Control/MarginContainer/HBoxContainer/VBoxContainer4.visible = false

func add_vine_soul():
	vine_souls += 1
	vine_label.text = "" + str(vine_souls)

func add_pine_soul():
	pine_souls += 1
	pine_label.text = "" + str(pine_souls)

func sub_vine_soul():
	vine_souls -= 1
	vine_label.text = "" + str(vine_souls)

func sub_pine_soul():
	pine_souls -= 1
	pine_label.text = "" + str(pine_souls)


func _input(event):
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
