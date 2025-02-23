extends AudioStreamPlayer

func _ready() -> void:
	stream = preload("res://menu/interact.wav")
	volume_db = -8
