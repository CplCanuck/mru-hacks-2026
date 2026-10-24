extends Control
func _on_button_pressed():
	MusicManager.play_music_step(MusicManager.music_step_type.BASE)

func _on_button_2_pressed():
	MusicManager.play_music_step(MusicManager.music_step_type.DEER)

func _on_button_3_pressed():
	MusicManager.play_music_step(MusicManager.music_step_type.BEAR)

func _on_button_4_pressed():
	MusicManager.play_music_step(MusicManager.music_step_type.FOX)

func _on_button_5_pressed():
	MusicManager.play_music_step(MusicManager.music_step_type.COMPLETE)

func _on_button_6_pressed():
	MusicManager.stop_all_music()

func _on_button_7_pressed():
	MusicManager.switch_music(MusicManager.song_type.MENU)

func _on_button_8_pressed():
	MusicManager.start_one_by_one()

func _on_button_9_pressed():
	MusicManager.stop_one_by_one()

func _on_button_10_pressed():
	MusicManager.add_next_music_step()
