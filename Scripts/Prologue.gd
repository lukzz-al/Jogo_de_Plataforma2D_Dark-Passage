extends Node2D

func _ready():
	$CanvasLayer/Label.visible = false
	pass # Replace with function body.

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		SceneChanger.change_scene("res://Scenes/Stage_1.tscn")

func _on_VideoPlayer_finished():
	SceneChanger.change_scene("res://Scenes/Stage_1.tscn")
	pass # Replace with function body.

func _on_Timer_timeout():
	$CanvasLayer/Label.visible = true
	pass # Replace with function body.
