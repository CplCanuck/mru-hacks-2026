extends Node
@onready var main_step_1 := $MainMusic/MainStep1
@onready var main_step_2 := $MainMusic/MainStep2
@onready var main_step_3 := $MainMusic/MainStep3
@onready var main_step_4 := $MainMusic/MainStep4
# @onready var main_step_5 := $MainMusic/MainStep5
@onready var menu_music := $Menu

const FADE_TIME = 5 # could be changed for different ones idfk

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
	await get_tree().create_timer(2.0).timeout
	fade_in_layer(main_step_1)
	await get_tree().create_timer(5.0).timeout
	fade_in_layer(main_step_2)
	await get_tree().create_timer(5.0).timeout
	fade_in_layer(main_step_3)
	await get_tree().create_timer(5.0).timeout
	fade_in_layer(main_step_4)
	

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
