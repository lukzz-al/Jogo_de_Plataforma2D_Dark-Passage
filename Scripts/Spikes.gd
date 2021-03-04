extends Sprite

func _ready():
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if body.get_name() == "Player":
		body.damage(100)
	pass # Replace with function body.
