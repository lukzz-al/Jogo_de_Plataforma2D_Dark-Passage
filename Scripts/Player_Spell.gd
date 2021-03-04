extends Area2D

onready var player = get_parent().get_node("Player")
onready var direction = 0 

func _ready():
	if player.sword_hitbox_side == "right":
		direction = 1
	elif player.sword_hitbox_side == "left":
		direction = -1
		
func _process(delta):
	var speed_x = 500 * direction
	var speed_y = 0
	var motion = Vector2(speed_x, speed_y)
	set_position(get_position() + motion * delta)
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if body.get_name().begins_with("Enemy") || body.get_name().begins_with("Boss"):
		body._take_damage(3)
	pass # Replace with function body.

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass # Replace with function body.
