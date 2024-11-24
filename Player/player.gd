extends CharacterBody2D

# Variáveis de controle da nave
@export var max_speed = 400
@export var acceleration = 600
@export var friction = 200  # Valor de atrito para desacelerar gradualmente
@export var rotation_speed = 3.0  # Velocidade de rotação em radianos por segundo
@export var strafe_speed = 150.0

var current_health: int
var damage_multiplier = 0.1  # Ajuste para calibrar o dano
var collided = false
var collected_itens = []
var current_collected_itens_used_space = 0

func _ready() -> void:
	current_health = PlayerStatus.current_integrity
	print(current_health)

func _process(delta):
	# Variável de direção
	var direction = 0

	# Controlar rotação da nave
	if Input.is_action_pressed("ui_left"):
		rotation -= rotation_speed * delta
	elif Input.is_action_pressed("ui_right"):
		rotation += rotation_speed * delta

	# Controlar movimento para frente e para trás
	if Input.is_action_pressed("ui_up"):
		# Mover para frente na direção atual da nave
		direction = 1
	elif Input.is_action_pressed("ui_down"):
		# Mover para trás na direção oposta
		direction = -1
	
	# Atualizar velocidade com base na direção e rotação
	if direction != 0:
		# Calcular vetor de movimento na direção apontada pela nave
		var forward_vector = Vector2.RIGHT.rotated(rotation) * direction
		velocity = velocity.move_toward(forward_vector * max_speed, acceleration * delta)
	else:
		# Aplicar atrito quando não houver entrada de movimento
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	# Movimento lateral (strafe)
	if Input.is_action_pressed("strafe_left"):
		velocity += Vector2.UP.rotated(rotation) * strafe_speed * delta
	elif Input.is_action_pressed("strafe_right"):
		velocity += Vector2.DOWN.rotated(rotation) * strafe_speed * delta
	
	# Mover a nave com a função move_and_slide
	move_and_slide()
	
	detect_collision()

func detect_collision():
	if get_slide_collision_count() > 0 && !collided:
		collided = true
		var impact_velocity = velocity.length()
		var damage = impact_velocity * damage_multiplier
		apply_damage(damage)
	elif get_slide_collision_count() == 0:
		collided = false

func apply_damage(damage):
	current_health -= damage
	print(current_health)
	if current_health <= 0:
		explode()

func explode():
	# Código para destruir a nave ou reiniciar o jogo
	PlayerStatus.restart()
	queue_free()

func get_current_health():
	return current_health

func add_item_to_collected_itens(item : Junk):
	if (item.size < PlayerStatus.max_storage - current_collected_itens_used_space ):
		current_collected_itens_used_space += item.size
		collected_itens.append(item)
		return true
	else:
		return false

func get_collected_itens():
	return collected_itens
