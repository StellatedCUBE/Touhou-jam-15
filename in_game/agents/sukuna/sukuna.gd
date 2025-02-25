extends Enemy

@onready var player_b: Player = player.get_node("%Behaviour")

var step: int = 0
var direction: int = 0
var size_timer: int = 0

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	step += 1
	var y: float = 0
	if step % 8 > 3:
		y = 16
	agent.texture.region = Rect2(direction * 16, y, 16, 16)
	
	if size_timer > 0:
		size_timer -= 1
		
		if size_timer > 370:
			agent.texture.region = Rect2(64, 0, 16, 16)
		elif size_timer > 340:
			agent.texture.region = Rect2(64, 16, 16, 16)
		
		if size_timer == 370:
			player_b.misfortune -= 10
			player_b.expand_sfx.play()
			
		var target_size: float = 1
		if size_timer > 100 and size_timer < 370:
			target_size = 2
			misfortune_required = 10
		else:
			misfortune_required = 0
		agent.size(move_toward(agent.scale.x, target_size, 0.0625))
		
		if size_timer == 100:
			%ShrinkSFX.play()
		
	elif player_b.misfortune >= 10 and randf() < 0.03:
		size_timer = 400
	
func wander() -> void:
	if size_timer > 340:
		return
	
	var move: Vector2 = Vector2.DOWN
	if direction == 1:
		move = Vector2.RIGHT
	elif direction == 2:
		move = Vector2.LEFT
	elif direction == 3:
		move = Vector2.UP
	
	var offset: Vector2 = player.global_position - agent.global_position
	if move.dot(offset) > 0:
		var moved: bool
		if direction == 0 or direction == 3:
			moved = agent.move_y(speed * move.y, speed)
		else:
			moved = agent.move_x(speed * move.x, speed)
		if not moved:
			if direction == d_primary(offset):
				direction = d_secondary(offset)
			else:
				direction = d_primary(offset)
	else:
		direction = d_primary(offset)
		if not offset.is_zero_approx():
			wander()

func d_primary(offset: Vector2) -> int:
	if abs(offset.x) > abs(offset.y):
		if offset.x > 0:
			return 1
		else:
			return 2
	elif offset.y > 0:
		return 0
	else:
		return 3

func d_secondary(offset: Vector2) -> int:
	if abs(offset.x) <= abs(offset.y):
		if offset.x > 0:
			return 1
		else:
			return 2
	elif offset.y > 0:
		return 0
	else:
		return 3
