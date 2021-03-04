extends Sprite

var in_range_interact = false
var next_scene

onready var text = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Player_interacting():
	if in_range_interact:
		SceneChanger.change_scene(next_scene)
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		in_range_interact = true
		text.visible = true
	pass # Replace with function body.

func _on_Area2D_body_exited(body):
	if body.get_name() == "Player":
		in_range_interact = false
		text.visible = false
	pass # Replace with function body.

func _on_World_next_scene(scene):
	next_scene = scene
	pass # Replace with function body.
