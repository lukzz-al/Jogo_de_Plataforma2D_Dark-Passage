extends Area2D

var in_range_interact = false

onready var player = get_parent().get_node("Player")
onready var text = $Label

func _ready():
	text.visible = false
	pass # Replace with function body.

func _on_Portal_body_entered(body):
	if body.get_name() == "Player":
		in_range_interact = true
		text.visible = true
	pass # Replace with function body.

func _on_Player_interacting():
	if in_range_interact:
		SceneChanger.change_scene("res://Scenes/Stage_2.tscn")
	pass # Replace with function body.

func _on_Portal_body_exited(body):
	if body.get_name() == "Player":
		in_range_interact = false
		text.visible = false
	pass # Replace with function body.
