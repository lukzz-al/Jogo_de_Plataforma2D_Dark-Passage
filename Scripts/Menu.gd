extends Control

onready var button_start = $MarginContainer/VBoxContainer/Start
onready var button_options = $MarginContainer/VBoxContainer/Option
onready var button_quit = $MarginContainer/VBoxContainer/Quit

func _ready():
	$MarginContainer/VBoxContainer/Start.grab_focus()

func _on_Start_pressed():
	SceneChanger.change_scene("res://Scenes/Prologue.tscn")
	pass # Replace with function body.

func _on_Start_focus_entered():
	button_start.modulate.r = 0.48
	button_start.modulate.g = 0.48
	button_start.modulate.b = 0.48
	$MarginContainer/VBoxContainer/Start/Som_menu.play()
	pass # Replace with function body.

func _on_Start_focus_exited():
	button_start.modulate.r = 1
	button_start.modulate.g = 1
	button_start.modulate.b = 1
	pass # Replace with function body.

func _on_Option_pressed():
	pass 
	modulate.r = 1
	modulate.g = 1
	modulate.b = 1
	pass # Replace with function body.

func _on_Option_focus_entered():
	button_options.modulate.r = 0.48
	button_options.modulate.g = 0.48
	button_options.modulate.b = 0.48
	$MarginContainer/VBoxContainer/Start/Som_menu.play()
	pass # Replace with function body.

func _on_Option_focus_exited():
	button_options.modulate.r = 1
	button_options.modulate.g = 1
	button_options.modulate.b = 1
	pass # Replace with function body.

func _on_Quit_pressed():
	get_tree().quit()
	pass # Replace with function body.

func _on_Quit_focus_entered():
	button_quit.modulate.r = 0.48
	button_quit.modulate.g = 0.48
	button_quit.modulate.b = 0.48
	$MarginContainer/VBoxContainer/Start/Som_menu.play()
	pass # Replace with function body.

func _on_Quit_focus_exited():
	button_quit.modulate.r = 1
	button_quit.modulate.g = 1
	button_quit.modulate.b = 1
	pass # Replace with function body.
