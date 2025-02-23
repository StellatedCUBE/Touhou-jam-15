extends Sprite2D

@export var into: String

var fade_in: int = 8
var fade_out: int = 0
var t: int = 0

func _ready() -> void:
	modulate.a = 0

func _physics_process(_delta: float) -> void:
	t += 1
	if t % 4 > 0:
		return
	if fade_in > 0:
		fade_in -= 1
		modulate.a = 1 - (fade_in as float / 8)
		$Input.consume_spin()
	elif fade_out > 0:
		modulate.a = 1 - (fade_out as float / 8)
		if fade_out > 8:
			get_tree().change_scene_to_file(into)
		fade_out += 1
	elif $Input.consume_spin():
		fade_out = 1

func _process(_delta: float) -> void:
	var vpr: Rect2 = get_viewport_rect()
	position = vpr.get_center()
	scale = Vector2.ONE * min(
		vpr.size.x / texture.get_width(),
		vpr.size.y / texture.get_height()
	)
