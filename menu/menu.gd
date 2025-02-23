extends Sprite2D

@export var states: Array[Texture] = []
@export var transitions: Array[Vector4i] = []
@export var destinations: Array[String] = []
@export var state: int = 0

func transition(to: int) -> void:
	if state != to:
		state = to
		UISFX.play()
	texture = states[to]

func _ready() -> void:
	transition(state)
	transform()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up") and transitions[state].x >= 0:
		transition(transitions[state].x)
		
	if Input.is_action_just_pressed("ui_down") and transitions[state].y >= 0:
		transition(transitions[state].y)
	
	if Input.is_action_just_pressed("ui_left") and transitions[state].z >= 0:
		transition(transitions[state].z)
	
	if Input.is_action_just_pressed("ui_right") and transitions[state].w >= 0:
		transition(transitions[state].w)
	
	transform()
	
	if Input.is_action_just_pressed("spin"):
		if destinations[state] == null or destinations[state] == "":
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
