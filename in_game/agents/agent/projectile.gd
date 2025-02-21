extends Node
class_name Projectile

@onready var agent: Agent = get_parent()

@export var speed = 0.0625
@export var damage: int = 2
var velocity: Vector2

func _ready() -> void:
	%Area.connect("area_entered", hit)

func hit(area: Area2D) -> void:
	if area.get_parent().name == "Player":
		var player: Player = area.get_node("%Behaviour")
		if player.spin_timer == 0 and area.name == "Area":
			player.damage(damage)
		elif area.name != "ExplosionArea":
			player.grant_misfortune()
	agent.queue_free()

func _physics_process(_delta: float) -> void:
	if not agent.move(velocity):
		agent.queue_free()
