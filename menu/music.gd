extends AudioStreamPlayer

func _ready() -> void:
	playback_type = 1
	stream = preload("res://menu/music.mp3")
	volume_db = -12

func play_() -> void:
	if not playing:
		play()
