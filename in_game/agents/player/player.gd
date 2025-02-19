extends Node

@onready var agent: Agent = get_parent()
@onready var input: InputManager = get_tree().root.get_node("World/%Input")

@export var speed: float = 0.0625
@export var adjust: float = 0.25

func _physics_process(_delta: float) -> void:
	var scale: float = agent.scale.x
	
	if input.left: agent.move_x(-speed, adjust * scale)
	elif input.right: agent.move_x(speed, adjust * scale)
	elif input.up: agent.move_y(-speed, adjust * scale)
	elif input.down: agent.move_y(speed, adjust * scale)
	
	if input.shrink and agent.scale.x > speed * 1.5: agent.change_size(-speed)
	if input.expand: agent.change_size(speed)
