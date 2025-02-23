extends Area2D
class_name DoorTile

var destination: String
var timer: int = 0

func _ready() -> void:
	connect("area_entered", hit)

func hit(area: Area2D) -> void:
	if area.name == "Area" and area.get_parent().name == "Player":
		get_tree().root.get_node("World/%Input").process_mode = Node.PROCESS_MODE_DISABLED
		timer = 32
		get_tree().root.get_node("World/%Fade").out()

func _physics_process(_delta: float) -> void:
	if timer > 0:
		timer -= 1
		if timer == 0:
			get_tree().change_scene_to_file(destination)
