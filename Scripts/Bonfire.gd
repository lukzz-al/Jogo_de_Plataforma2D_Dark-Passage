extends AnimatedSprite

onready var player = get_parent().get_node("Player")
onready var warning = preload("res://Scenes/Warnings.tscn").instance()
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var text = $Label

var in_range_interact = false
var usable = true

func _on_Player_interacting():
	if in_range_interact:
		if player.health < 100 && usable:
			player._set_health(100)
			usable = false
			state_machine.travel("dead")
		elif !usable:
			warning.visible = true
			warning.set_text("Você já usou essa fogueira!")
		elif player.health == 100:
			warning.visible = true
			warning.set_text("Você já está com a vida cheia!")
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
		warning.visible = false
	pass # Replace with function body.
