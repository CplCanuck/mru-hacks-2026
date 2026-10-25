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

func add_vine_soul():
	vine_souls += 1
	vine_label.text = str(vine_souls)

func add_pine_soul():
	pine_souls += 1
	pine_souls.text = str(pine_souls)

func sub_vine_soul():
	vine_souls -= 1
	vine_label.text = str(vine_souls)

func sub_pine_soul():
	pine_souls -= 1
	pine_souls.text = str(pine_souls)
