extends Area2D

enum type {
	DEER,
	BEAR
}
enum state {
	TIRED,
	REBITALIZED
}

@export var animal = type.DEER
@export var cur = state.TIRED

var tired_s
var revit_s
var idle_s

func _ready():
	if animal == type.DEER:
		tired_s = "d_tired"
		revit_s = "d_revitalized" 
		idle_s = "d_idle"
	elif animal == type.BEAR:
		tired_s = "b_tired"
		revit_s = "b_revitalized" 
		idle_s = "b_idle"
	pass

func _on_body_entered(body):
	match cur:
		state.TIRED:
			match animal:
				type.DEER:
					if Backpack.has_deer_soul:
						make_live()
						pass
				pass
				type.BEAR:
					if Backpack.has_bear_soul:
						make_live()
						pass
				pass
			pass
		state.REBITALIZED:
			
			pass
	pass 

func make_live():
	pass
