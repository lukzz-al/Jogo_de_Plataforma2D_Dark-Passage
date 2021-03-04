extends Area2D

var velocity = Vector2(0,4)


func _physics_process(delta):
	
	position.y+=velocity.y
	
	pass

func _on_Storm_rage_body_entered(body):
	if body.get_name() == "Player":
		body.damage(10)
	elif body.get_name() != "Enemy":
		queue_free()
