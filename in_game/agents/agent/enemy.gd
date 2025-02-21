extends Node

@onready var agent: Agent = get_parent()
@onready var player: Agent = get_tree().root.get_node("World/%Player")

@export var health: int = 1
@export var damage: int = 1
@export var projectile: PackedScene = null
@export var fire_delay: int = 120
@export var misfortune_required: int = 0

var iframes: int = 0
var knockback: Vector2 = Vector2.ZERO
var reload_time: int = 0

func _ready() -> void:
	%Area.connect("area_entered", hit)

func hit(area: Area2D) -> void:
	if area.name == "SpinArea" and iframes == 0:
		var player: Player = area.get_node("%Behaviour")
		if player.misfortune < misfortune_required:
			return
		health -= 1
		iframes = 20
		knockback = (agent.global_position - area.global_position).normalized() * 0.08
		player.grant_misfortune()
	elif area.name == "ExplosionArea":
		health -= 10
	elif area.get_parent().name == "Player":
		area.get_node("%Behaviour").damage(damage)

func _physics_process(_delta: float) -> void:
	if iframes > 0:
		iframes -= 1
	
	agent.visible = iframes % 2 == 0
	
	if health <= 0:
		agent.queue_free()
	
	if knockback.length_squared() > 0.000001:
		if not agent.move_x(knockback.x, 0.01):
			knockback.x = 0
		if not agent.move_y(knockback.y, 0.01):
			knockback.y = 0
		knockback *= 0.92
	else:
		knockback = Vector2.ZERO

	if reload_time > 0:
		reload_time -= 1
	elif projectile != null:
		var sample_pos: Vector2 = agent.global_position
		while true:
			sample_pos = sample_pos.move_toward(player.global_position, 0.125)
			if sample_pos == player.global_position:
				reload_time = fire_delay
				var instance: Node2D = projectile.instantiate()
				agent.get_parent().add_child(instance)
				agent.get_parent().move_child(instance, 0)
				instance.global_position = agent.global_position
				var p_instance: Projectile = instance.get_node("%Behaviour")
				p_instance.velocity = agent.global_position.direction_to(player.global_position) * p_instance.speed
				break
			if agent.map.get_cell_tile_data(agent.map.local_to_map(agent.map.to_local(sample_pos))).get_custom_data("Solid"):
				break
