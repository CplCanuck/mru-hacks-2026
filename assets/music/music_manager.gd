extends Node
@onready var main_step_1 := $MainMusic/MainStep1
@onready var main_step_2 := $MainMusic/MainStep2
@onready var main_step_3 := $MainMusic/MainStep3
@onready var main_step_4 := $MainMusic/MainStep4
# @onready var main_step_5 := $MainMusic/MainStep5
@onready var menu_music := $Menu

const FADE_TIME = 1.0 # could be changed for different ones idfk

var step_intro_time := 4
var music_steps := []

enum song_type {
	MENU,
	START,
	MAIN,
}

enum music_step_type {
	BASE,
	DEER,
	BEAR,
	COMPLETE
}



# start every song at once (in sync)
# "solo" the cutscene music
# when cutscene is over:
# 	mute it, and solo the base layer
# every subsequent event (deer, bear, ending):
#	"un-solo" its layer


func _ready():
	music_steps = [main_step_1, main_step_2, main_step_3, main_step_4]
	start_all_music()
	
	# remove this if we want to play cutscene music yeah
	fade_in_layer(main_step_1)
	
	

func fade_in_layer(step :AudioStreamPlayer):
	var tween = create_tween()
	tween.tween_property(step, "volume_linear", .9, FADE_TIME)



## Starts all audio players 
## (all steps and menu at same time for testing)
func start_all_music():
	var children = get_all_descendants(self)
	#var tween = create_tween()
	for child in children:
		if child is AudioStreamPlayer:
			turn_on_music(child, 0)
	pass


## Starts an audio player
func turn_on_music(audio_player :AudioStreamPlayer, position :float):
	audio_player.volume_linear = 0
	audio_player.play(position)



## Helper function for getting all audio players under manager
func get_all_descendants(node: Node) -> Array:
	var result = []
	for child in node.get_children():
		result.append(child)
		result += get_all_descendants(child)
	return result


func _on_shrine__on_shrine_success(position: Vector2) -> void:
	print("DEBUG: step 3 triggered")
	fade_in_layer(main_step_3)


func _on_shrine_1__on_shrine_success(position: Vector2) -> void:
	print("DEBUG: step 2 triggered")
	fade_in_layer(main_step_2)


func _on_final_area_body_entered(body: Node2D) -> void:
	if body.name == "player":
		print("DEBUG: step 4 triggered")
		fade_in_layer(main_step_4)
