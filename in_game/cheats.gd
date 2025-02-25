extends AudioStreamPlayer

var on: bool = false

func _ready() -> void:
	stream = preload("res://in_game/clear.wav")

func enable() -> void:
	if not on:
		on = true
		play()
