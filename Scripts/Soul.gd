extends AnimatedSprite

onready var player = get_parent().get_node("Player")

func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		player._set_souls(1)
		queue_free()
