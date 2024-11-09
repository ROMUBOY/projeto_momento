#extends CharacterBody2D
#
#const SPEED = 300.0
#
#func _physics_process(delta):
	#motion_mode = 1
	#var input_vector = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	#input_vector = input_vector.normalized()
	#velocity = input_vector * SPEED
#
	#move_and_slide()
# Variáveis de controle da nave
#extends CharacterBody2D
#
## Variáveis de controle da nave
#@export var max_speed = 400
#@export var acceleration = 600
#@export var friction = 200  # Valor de atrito para desacelerar gradualmente
#
#func _process(delta):
	#var direction = Vector2.ZERO
#
	## Verificar entrada de movimento
	#if Input.is_action_pressed("ui_up"):
		#direction.y -= 1
	#if Input.is_action_pressed("ui_down"):
		#direction.y += 1
	#if Input.is_action_pressed("ui_left"):
		#direction.x -= 1
	#if Input.is_action_pressed("ui_right"):
		#direction.x += 1
#
	## Atualizar a velocidade com base na direção
	#if direction != Vector2.ZERO:
		#direction = direction.normalized()  # Normalizar para manter velocidade constante
		#velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	#else:
		## Aplicar o atrito quando não houver entrada
		#velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
#
	## Mover a nave com a função move_and_slide
	#move_and_slide()

extends CharacterBody2D

# Variáveis de controle da nave
@export var max_speed = 400
@export var acceleration = 600
@export var friction = 200  # Valor de atrito para desacelerar gradualmente
@export var rotation_speed = 3.0  # Velocidade de rotação em radianos por segundo

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

	# Mover a nave com a função move_and_slide
	move_and_slide()
