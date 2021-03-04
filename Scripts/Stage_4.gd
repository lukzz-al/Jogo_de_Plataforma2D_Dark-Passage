extends Node2D

signal camera_limits(left, top, right, bottom)

# Called when the node enters the scene tree for the first time.
func _ready():
	var camera_left = 1
	var camera_top = -10000
	var camera_right = 1425.428
	var camera_bottom = 352
	emit_signal("camera_limits", camera_left, camera_top, camera_right, camera_bottom)
	
	pass # Replace with function body.



func _on_Boss_end_game():
	$Credits.start()
	pass # Replace with function body.


func _on_Credits_timeout():
	SceneChanger.change_scene("res://Scenes/Credits.tscn")
	pass # Replace with function body.
