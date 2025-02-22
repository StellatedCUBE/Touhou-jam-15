extends Camera2D
class_name Camera

@export var width: float = 16
@export var height: float = 9
@export var transition_speed: float = 0.25

var transition_target: Vector2
var transitioning: bool = false
var map_pos: Vector2 = Vector2.ZERO

func _ready() -> void:
	update_agent_modes()

func _process(delta: float) -> void:
	var vps: Vector2 = get_viewport().size
	zoom = Vector2.ONE * (vps.x / width)
	position = Vector2(width / 2, width * vps.y / vps.x / 2) + map_pos
	
	if transitioning:
		map_pos = map_pos.move_toward(transition_target, transition_speed * delta * 60)
		if map_pos == transition_target:
			transitioning = false
			update_agent_modes()
			get_tree().paused = false

func transition(by: Vector2) -> void:
	transition_to(map_pos + Vector2(by.x * (width - 1), by.y * (height - 1)))
	
func transition_to(target: Vector2) -> void:
	transition_target = target
	transitioning = true
	get_tree().paused = true

func update_agent_modes() -> void:
	var rect: Rect2 = Rect2(map_pos, Vector2(width, height))
	for agent: Node2D in %Agents.get_children():
		if rect.has_point(agent.global_position):
			agent.process_mode = Node.PROCESS_MODE_PAUSABLE
		else:
			agent.process_mode = Node.PROCESS_MODE_DISABLED
