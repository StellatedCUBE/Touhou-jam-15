extends Node

@export var misfortune_required: int = 10
@export var speed_multiplier: float = 0.5

@onready var agent: Agent = get_parent()

var pushed_this_tick: bool = false

func _physics_process(_delta: float) -> void:
	pushed_this_tick = false

func pushed_by(pusher: Agent) -> void:
	if pusher.name != "Player" or pushed_this_tick:
		return
	pushed_this_tick = true
	var player: Player = pusher.get_node("%Behaviour")
	if player.misfortune < misfortune_required:
		return
	var speed: float = player.speed * speed_multiplier
	var offset: Vector2 = agent.global_position - pusher.global_position
	if abs(offset.x) > abs(offset.y):
		agent.move_x(sign(offset.x) * speed, player.adjust)
	else:
		agent.move_y(sign(offset.y) * speed, player.adjust)
