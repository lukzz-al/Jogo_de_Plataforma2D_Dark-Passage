extends Control


func _ready():
	$MarginContainer/CenterContainer/VBoxContainer/Button.grab_focus()
	
func _physics_process(delta):
	if $MarginContainer/CenterContainer/VBoxContainer/Button.is_hovered() == true:
		$MarginContainer/CenterContainer/VBoxContainer/Button.grab_focus()
	if $MarginContainer/CenterContainer/VBoxContainer/Button2.is_hovered() == true:
		$MarginContainer/CenterContainer/VBoxContainer/Button2.grab_focus()
	
func _input(event):
	if event.is_action_pressed("pause"):
		$MarginContainer/CenterContainer/VBoxContainer/Button.grab_focus()
		get_tree().paused = not get_tree().paused
		visible = not visible

func _on_Button_pressed():
	get_tree().paused = not get_tree().paused
	visible = not visible
	pass

func _on_Button2_pressed():
	get_tree().quit()
	pass 
