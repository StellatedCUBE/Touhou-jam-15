extends Node
class_name InputManager

var left: bool = false
var right: bool = false
var up: bool = false
var down: bool = false

var kspin: bool = false
var spin: bool = false
var kexplode: bool = false
var explode: bool = false

var shrink: bool = false
var expand: bool = false

func _process(_delta: float) -> void:
	var stick: Vector2 = (Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * 256).round()
	
	var x_dominant: bool = abs(stick.x) > abs(stick.y)
	var y_dominant: bool = abs(stick.y) > abs(stick.x)
	
	var kleft: bool = x_dominant and stick.x < 0
	var kright: bool = x_dominant and stick.x > 0
	var kup: bool = y_dominant and stick.y < 0
	var kdown: bool = y_dominant and stick.y > 0
	left = kleft and not (kright or kup or kdown)
	right = kright and not (kleft or kup or kdown)
	up = kup and not (kleft or kright or kdown)
	down = kdown and not (kleft or kright or kup)

	var lkspin: bool = kspin
	kspin = Input.is_action_pressed("spin")
	if kspin and not lkspin:
		spin = true
	
	var lkexplode: bool = kexplode
	kexplode = Input.is_action_pressed("explode")
	if kexplode and not lkexplode:
		explode = true

	shrink = Input.is_key_pressed(KEY_PAGEDOWN)
	expand = Input.is_key_pressed(KEY_PAGEUP)

func consume_spin() -> bool:
	if spin:
		spin = false
		return true
	return false

func consume_explode() -> bool:
	if explode:
		explode = false
		return true
	return false
