extends Node
@onready var main_step_1 = $MainMusic/MainStep1
@onready var main_step_2 = $MainMusic/MainStep2
@onready var main_step_3 = $MainMusic/MainStep3
@onready var main_step_4 = $MainMusic/MainStep4
@onready var main_step_5 = $MainMusic/MainStep5
@onready var menu_music = $Menu

var step_intro_time = 5
var music_steps = []

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

var cur_music_step = 0

func _ready():
	music_steps = [main_step_1, main_step_2, main_step_3, main_step_4, main_step_5]
	#switch_music(song_type.MENU)
	await start_all_music()
	start_cutscene_music()

func switch_music(song: song_type):
	match song:
		song_type.MENU:
			turn_on_music(menu_music, 0)
			pass
		song_type.START:
			print("Use .start_cutscence() instead")
			pass
		song_type.MAIN:
			if cur_music_step == 0:
				add_music_step()
			pass
		_:
			print("Can't switch main music to invalid song type. Check input in calling function")
			pass
	pass

## Return value:
## int - 1 when finished the song.
func start_cutscene_music() -> int:
	stop_one_by_one()
	return 1

func stop_one_by_one(time=4) -> int:
	var reverse_steps = music_steps.duplicate()
	reverse_steps.reverse()
	for music in reverse_steps:
		stop_one(music, time)
	return 1

func stop_one(audio :AudioStreamPlayer, time=0):
	var timer
	audio.stop()
	timer = get_tree().create_timer(time)
	await timer.timeout

func start_one_by_one(time=4) -> int:
	for music in music_steps:
		start_one(music, time)
	return 1

func start_one(audio : AudioStreamPlayer, time=0):
	turn_on_music(audio, 0)
	await wait_for_song_time(audio, time)
	pass
	
func wait_for_song_time(audio : AudioStreamPlayer, seconds: float) -> void:
	while audio.playing and audio.get_playback_position() < seconds:
		await get_tree().process_frame
	pass

## Parameter: music step enum
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

## Unused?
func add_music_step():
	cur_music_step = cur_music_step + 1
	if cur_music_step <= 0:
		print("cur_music step was negative. Changing to 1.")
		cur_music_step = 1
	if main_step_1.playing == false:
		turn_on_music(main_step_1, 0)
	elif main_step_2.playing == false:
		turn_on_music(main_step_2, 0)
	pass
	
func turn_on_music(audio_player :AudioStreamPlayer, position :float, slow=true):
	if audio_player.playing == false:
		if slow:
			audio_player.volume_db = -50
			audio_player.play(position)
			var tween = create_tween()
			tween.tween_property(audio_player, "volume_db", 0, 1)
		else:
			audio_player.play(position)
		
		pass
	pass
	

func turn_off_music(audio_player :AudioStreamPlayer):
	if audio_player.playing:
		var tween = create_tween()
		tween.tween_property(audio_player, "volume_db", -40, 1)
		await tween.finished
		audio_player.playing = false
		pass
	pass
	
func stop_all_music():
	var children = get_all_descendants(self)
	#var tween = create_tween()
	for child in children:
		if child is AudioStreamPlayer:
			if child.playing:
				#tween.tween_property(child, "volume_db", -40, 0.5)
				child.playing = false
	pass

func start_all_music():
	var children = get_all_descendants(self)
	#var tween = create_tween()
	for child in children:
		if child is AudioStreamPlayer:
			turn_on_music(child, 0, false)
	pass

func get_all_descendants(node: Node) -> Array:
	var result = []
	for child in node.get_children():
		result.append(child)
		result += get_all_descendants(child)
	return result
