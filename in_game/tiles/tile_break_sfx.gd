extends AudioStreamPlayer

var scheduled: bool = false

func _ready() -> void:
	stream = preload("res://in_game/tiles/break.wav")
	process_mode = Node.PROCESS_MODE_ALWAYS

func _physics_process(_delta: float) -> void:
	if scheduled:
		if playing:
			var child: AudioStreamPlayer = AudioStreamPlayer.new()
			child.stream = stream
			child.process_mode = Node.PROCESS_MODE_ALWAYS
			child.volume_db = volume_db
			add_child(child)
			child.play()
		else:
			play()
		scheduled = false
	
	else:
		for child: AudioStreamPlayer in get_children():
			if not child.playing:
				child.queue_free()
