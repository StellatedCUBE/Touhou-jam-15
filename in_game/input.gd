extends Node
class_name InputManager

var left: bool = false
var right: bool = false
var up: bool = false
var down: bool = false

var spin: bool = false 

var shrink: bool = false
var expand: bool = false

func _process(_delta: float) -> void:
	var kleft: bool = Input.is_key_pressed(KEY_LEFT)
	var kright: bool = Input.is_key_pressed(KEY_RIGHT)
	var kup: bool = Input.is_key_pressed(KEY_UP)
	var kdown: bool = Input.is_key_pressed(KEY_DOWN)
	left = kleft and not (kright or kup or kdown)
	right = kright and not (kleft or kup or kdown)
	up = kup and not (kleft or kright or kdown)
	down = kdown and not (kleft or kright or kup)

	spin = Input.is_key_pressed(KEY_Z)

	shrink = Input.is_key_pressed(KEY_PAGEDOWN)
	expand = Input.is_key_pressed(KEY_PAGEUP)
