extends Node

@onready var agent: Agent = get_parent()
@onready var input: InputManager = get_tree().root.get_node("World/%Input")

@export var speed: float = 0.0625

func _physics_process(_delta: float) -> void:
	
	if input.left: agent.move(Vector2(-speed, 0))
	if input.right: agent.move(Vector2(speed, 0))
	if input.up: agent.move(Vector2(0, -speed))
	if input.down: agent.move(Vector2(0, speed))
