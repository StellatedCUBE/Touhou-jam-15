extends Polygon2D

var fade_in: int = 8
var fade_out: int = 0
var t: int = 0

func _ready() -> void:
	visible = true

func _physics_process(_delta: float) -> void:
	t += 1
	if t % 4 > 0:
		return
	if fade_in > 0:
		fade_in -= 1
		modulate.a = fade_in as float / 8
	elif fade_out > 0:
		modulate.a = fade_out as float / 8
		if fade_out < 8:
			fade_out += 1

func out() -> void:
	fade_out = 1
