extends Sprite2D

@export var states: Array[Texture] = []
@export var transitions: Array[Vector4i] = []
@export var destinations: Array[String] = []
@export var state: int = 0

var code: String = ""

func transition(to: int) -> void:
	if to < 0:
		return
	if state != to:
		state = to
		UISFX.play()
	texture = states[to]

func _ready() -> void:
	transition(state)
	transform()
	MenuMusic.play_()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		transition(transitions[state].x)
		code += "u"
		
	if Input.is_action_just_pressed("ui_down"):
		transition(transitions[state].y)
		code += "d"
	
	if Input.is_action_just_pressed("ui_left"):
		transition(transitions[state].z)
		code += "l"
	
	if Input.is_action_just_pressed("ui_right"):
		transition(transitions[state].w)
		code += "r"
	
	transform()
	
	if Input.is_action_just_pressed("explode"):
		code += "x"
	
	if Input.is_action_just_pressed("spin"):
		if code.ends_with("uuddlrlrx"):
			Cheats.enable()
			code = ""
		elif destinations[state] == null or destinations[state] == "":
			get_tree().quit()
		else:
			UISFX.play()
			get_tree().change_scene_to_file(destinations[state])

func transform() -> void:
	var vpr: Rect2 = get_viewport_rect()
	position = vpr.get_center()
	scale = Vector2.ONE * min(
		vpr.size.x / texture.get_width(),
		vpr.size.y / texture.get_height()
	)
