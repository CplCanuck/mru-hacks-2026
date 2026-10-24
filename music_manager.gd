extends Node
@onready var main_step_1 := $MainMusic/MainStep1
@onready var main_step_2 := $MainMusic/MainStep2
@onready var main_step_3 := $MainMusic/MainStep3
@onready var main_step_4 := $MainMusic/MainStep4
@onready var main_step_5 := $MainMusic/MainStep5
@onready var menu_music := $Menu

var step_intro_time := 5
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
	FOX,
	COMPLETE
}

#var cur_music_step := 0

## Set up global steps and starts cutscene music
## WIP change to menu
func _ready():
	music_steps = [main_step_1, main_step_2, main_step_3, main_step_4, main_step_5]
	#switch_music(song_type.MENU)
	start_cutscene_music()

## Switch to a specific track
func switch_music(song: song_type):
	match song:
		song_type.MENU:
			turn_on_music(menu_music, 0)
			pass
		song_type.START:
			print("Use .start_cutscence() instead")
			pass
		song_type.MAIN:
			add_next_music_step()
			pass
		_:
			print("Can't switch main music to invalid song type. Check input in calling function")
			pass
	pass

## Cutscene music fades away as world decays
## Return value:
## int - 1 when finished the song.
func start_cutscene_music() -> int:
	print("1. Starting music")
	await start_all_music()
	print("2. Stopping one by one")
	await stop_one_by_one()
	return 1

## Fades the music by taking 1 instrutment at a time
func stop_one_by_one(time=4) -> int:
	var reverse_steps = music_steps.duplicate()
	reverse_steps.reverse()
	for music in reverse_steps:
		if music.playing == true:
			await stop_one(music, time)
	return 1

## Stops track and wait some time
func stop_one(audio :AudioStreamPlayer, time=0):
	var timer
	audio.stop()
	print("Stopped: " + str(audio))
	timer = get_tree().create_timer(time)
	await timer.timeout
	return 0

## Fade music in
func start_one_by_one(time=4) -> int:
	print("1. Starting one by one")
	for music in music_steps:
		if music.playing == false:
			await start_one(music, time)
	return 1

## Decide whether if it's the first step
## Starts magic at the right time on the track 
## WIP actually starts all steps at once NOT at the right time
func start_one(audio : AudioStreamPlayer, time=4):
	if main_step_1.playing == false:
		turn_on_music(audio, 0)
	else:
		var timer = get_tree().create_timer(time)
		await timer.timeout
		await wait_for_song_time(main_step_1, time)
		await turn_on_music(audio, main_step_1.get_playback_position())
		# print("Started: " + str(audio))
	return 0
	
# Waits until the main track is in a spot where another intrustment can be added
func wait_for_song_time(audio : AudioStreamPlayer, seconds: float):
	while audio.playing and audio.get_playback_position() < seconds:
		await get_tree().process_frame
	return 0

## Parameter: music step enum
## Start specific intrustments
func play_music_step(step: music_step_type):
	match step:
		music_step_type.BASE:
			turn_on_music(main_step_1, 0)
		music_step_type.DEER:
			await wait_for_song_time(main_step_1, step_intro_time)
			turn_on_music(main_step_2, main_step_1.get_playback_position())
		music_step_type.BEAR:
			await wait_for_song_time(main_step_1, step_intro_time)
			turn_on_music(main_step_3, main_step_1.get_playback_position())
		music_step_type.FOX:
			await wait_for_song_time(main_step_1, step_intro_time)
			turn_on_music(main_step_4, main_step_1.get_playback_position())
		music_step_type.COMPLETE:
			await wait_for_song_time(main_step_1, step_intro_time)
			turn_on_music(main_step_5, main_step_1.get_playback_position())
		_:
			print("Can't play invalid music_step_type. Check input in calling function")
			pass
	pass

## Instructments can be added in a set order too
func add_next_music_step():
	#cur_music_step = cur_music_step + 1
	#if cur_music_step <= 0:
	#	print("cur_music step was negative. Changing to 1.")
	#	cur_music_step = 1
	if main_step_1.playing == false:
		turn_on_music(main_step_1, 0)
	else:
		for music in music_steps:
			if music.playing == false:
				turn_on_music(music, main_step_1.get_playback_position())
				break
	pass

## Starts an audio player
func turn_on_music(audio_player :AudioStreamPlayer, position :float, time=0.1):
	if audio_player.playing == false:
		audio_player.volume_db = -50
		audio_player.play(position)
		print("Turned on: " + str(audio_player))
		var tween = create_tween()
		tween.tween_property(audio_player, "volume_db", 0, time)
		await tween.finished
		pass
	pass

## Stops a audio player
func turn_off_music(audio_player :AudioStreamPlayer, time=0):
	if audio_player.playing:
		var tween = create_tween()
		tween.tween_property(audio_player, "volume_db", -40, time)
		await tween.finished
		audio_player.playing = false
		print("Turned off: " + str(audio_player))
		await tween.finished
		pass
	pass
	
# Stops all audio players
func stop_all_music():
	var children = get_all_descendants(self)
	for child in children:
		if child is AudioStreamPlayer:
			if child.playing:
				child.playing = false
	pass

## Starts all audio players 
## (all steps and menu at same time for testing)
func start_all_music():
	var children = get_all_descendants(self)
	#var tween = create_tween()
	for child in children:
		if child is AudioStreamPlayer:
			turn_on_music(child, 0, 3)
	pass

## Helper function for getting all audio players under manager
func get_all_descendants(node: Node) -> Array:
	var result = []
	for child in node.get_children():
		result.append(child)
		result += get_all_descendants(child)
	return result
