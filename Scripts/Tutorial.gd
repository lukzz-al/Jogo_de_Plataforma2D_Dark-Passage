extends Node2D

var images = [
	"res://Sprites/HUD/Keyboard.png",
	"res://Sprites/HUD/shift_key.png",
	"res://Sprites/HUD/space_key.png",
	"res://Sprites/HUD/letter_e.png",
	"res://Sprites/HUD/letter_z.png",
	"res://Sprites/HUD/letter_x.png",
	
]

onready var player = get_parent().get_node("Player")
onready var tutorial_label = get_parent().get_node("CanvasLayer/Tutorial")
onready var img_tutorial = get_parent().get_node("CanvasLayer/Tutorial/Img_tutorial")

func _ready():
	img_tutorial.visible = true
	tutorial_label.set_text("Use as teclas direcionas do teclado para poder movimentar o personagem")
	img_tutorial.texture = load("res://Sprites/HUD/Keyboard.png")
	pass # Replace with function body.

func _on_Shift_intro_body_entered(body):
	if body.get_name() == "Player":
		tutorial_label.set_text("Se estiver com pressa, use 'Shift' ou LT em seu controle para correr mais rápido")
		img_tutorial.texture = load("res://Sprites/HUD/shift_key.png")
		$Shift_intro.queue_free()
	pass # Replace with function body.

func _on_SpaceBar_intro_body_entered(body):
	if body.get_name() == "Player":
		tutorial_label.set_text("Ao se deparar com um obstáculo, pode pula-ló usando a tecla 'Barra de Espaço' ou 'A' em seu controle")
		img_tutorial.texture = load("res://Sprites/HUD/space_key.png")
		$Screen_Cleaner.wait_time   = 4
		$Screen_Cleaner.start()
		$SpaceBar_intro.queue_free()
	pass # Replace with function body.

func _on_ShiftSpace_intro_body_entered(body):
	if body.get_name() == "Player":
		tutorial_label.set_text("Vamos tentar um pulo maior, use seu impulso para realizar o salto")
		img_tutorial.visible = false
		$Screen_Cleaner.wait_time = 4
		$Screen_Cleaner.start()
		$Shift_Space_intro.queue_free()
	pass # Replace with function body.

func _on_Spikes_body_entered(body):
	if body.get_name() == "Player":
		tutorial_label.set_text("Cuidado com as armadilhas, elas podem machucar")
		img_tutorial.visible = false
		$Screen_Cleaner.wait_time = 3
		$Screen_Cleaner.start()
		$Spikes.queue_free()
	pass # Replace with function body.

func _on_Z_intro_body_entered(body):
	if body.get_name() == "Player":
		tutorial_label.set_text("Falando em coisas que podem machucar ... logo a frente tem um inimigo use a tecla 'Z' ou 'X' em seu controle para ataca-lo " )
		img_tutorial.visible = true
		img_tutorial.texture = load("res://Sprites/HUD/letter_z.png")
		$Screen_Cleaner.wait_time = 4
		$Screen_Cleaner.start()
		$Z_intro.queue_free()
	pass # Replace with function body.

func _on_Enemy_tutorial_pts():
	player.is_dead = true
	tutorial_label.set_text("Ao derrotar um inimigo você pode coletar a alma dele, as almas são os pontos, quantas mais você tiver no final do jogo, melhor foi seu desempenho." )
	img_tutorial.visible = false
	$Points_intro.start()
	pass # Replace with function body.

func _on_Points_intro_timeout():
	tutorial_label.set_text("Mas tome cuidado, ao morrer, você perde metade das suas almas coletadas!")
	img_tutorial.visible = false
	$Spell_intro.start()
	player.is_dead = false
	pass # Replace with function body.

func _on_Spell_intro_timeout():
	tutorial_label.set_text("Alem do ataque normal, você pode usar o seu ataque especial apertando a tecla 'X' ou 'Y' em seu controle.")
	img_tutorial.visible = true
	img_tutorial.texture = load("res://Sprites/HUD/letter_x.png")
	$Spell_intro2.start()
	pass # Replace with function body.

func _on_Spell_intro2_timeout():
	tutorial_label.set_text("Mas cuidado, ao usar o ataque especial, ele consome 'mana', e sem ela você não pode usa-lo")
	img_tutorial.visible = false
	$Screen_Cleaner.wait_time = 6
	$Screen_Cleaner.start()
	pass # Replace with function body.

func _on_Bonfire_intro_body_entered(body):
	if body.get_name() == "Player":
		tutorial_label.set_text("Se não estiver com a vida cheia, procure por fogueiras, elas são um ótimo local de descanso")
		$Screen_Cleaner.wait_time = 5
		$Screen_Cleaner.start()
		$Bonfire_intro.queue_free()
	pass # Replace with function body.

func _on_Portal_intro_body_entered(body):
	if body.get_name() == "Player":
		tutorial_label.set_text("Muito bem, agora que você já sabe o básico está pronto para a jornada, entre no portal para finalizar o Tutorial.")
		$Screen_Cleaner.wait_time = 5
		$Screen_Cleaner.start()
		$Portal_intro.queue_free()
	pass # Replace with function body.

func _on_Screen_Cleaner_timeout():
	tutorial_label.set_text("")
	img_tutorial.visible = false
	pass # Replace with function body.
