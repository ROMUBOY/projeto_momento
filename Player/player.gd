extends CharacterBody2D

# Variáveis de controle da nave
@export var max_speed = 400
@export var acceleration = 130
@export var friction = 100  # Valor de atrito para desacelerar gradualmente
@export var rotation_speed = 3.0  # Velocidade de rotação em radianos por segundo
@export var strafe_speed = 0.00000001

var current_health: int
var damage_multiplier = 0.1  # Ajuste para calibrar o dano
var collided = false
var collected_itens = []
var current_collected_itens_used_space = 0

var fuel: float = PlayerStatus.max_fuel  # Combustível inicial
var fuel_burn_rate: float = 3.0  # Taxa de consumo por segundo
@export var current_filter = 0
var filter_burn_rate_multiplier = 1 + 1 / PlayerStatus.filter_efficiency

signal player_died

signal player_damage

signal player_consume_fuel

func _ready() -> void:
	current_health = PlayerStatus.current_integrity

func _process(delta):
	if fuel > 0:
		process_rotation(delta)
	
		process_movement(delta)
		
		process_strafe(delta)
		
		move_and_slide()
		
		detect_collision()
		
		burn_fuel(delta)
	else:
		explode()

func process_rotation(delta):	
	if Input.is_action_pressed("ui_left"):
		rotation -= rotation_speed * delta
	elif Input.is_action_pressed("ui_right"):
		rotation += rotation_speed * delta

func process_movement(delta):
	var direction = direction()
		
	if direction != 0:
		var forward_vector = Vector2.RIGHT.rotated(rotation) * direction
		velocity = velocity.move_toward(forward_vector * max_speed, (acceleration + PlayerStatus.propulsion_power * 10 )* delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

func direction():
	var direction = 0
	
	if Input.is_action_pressed("ui_up"):
		direction = 1
	elif Input.is_action_pressed("ui_down"):
		direction = -1
	
	return direction

func process_strafe(delta):
	if Input.is_action_pressed("strafe_left"):
		velocity += Vector2.UP.rotated(rotation) * strafe_speed * delta
	elif Input.is_action_pressed("strafe_right"):
		velocity += Vector2.DOWN.rotated(rotation) * strafe_speed * delta

func burn_fuel(delta):
	if Input.is_action_pressed("ui_up"):
		fuel -= fuel_burn_rate * delta * ( filter_burn_rate_multiplier if (current_filter != 0) else 1)
		emit_signal("player_consume_fuel")
		fuel = max(fuel, 0)
		print("Combustível restante: ", fuel)

func detect_collision():
	if get_slide_collision_count() > 0 && !collided:
		collided = true
		var impact_velocity = velocity.length()
		var damage = impact_velocity * damage_multiplier if (impact_velocity > 10) else 0
		apply_damage(damage)
	elif get_slide_collision_count() == 0:
		collided = false

func apply_damage(damage):
	current_health -= damage
	if (damage > 0):
		SoundPlayer.play_sound(SoundPlayer.HURT_SOUND)
		emit_signal("player_damage")
	if current_health <= 0:
		explode()

func explode():
	SoundPlayer.play_sound(SoundPlayer.DIED_SOUND)
	collected_itens = []
	get_tree().change_scene_to_file("res://died_screen.tscn")
	PlayerStatus.current_integrity = PlayerStatus.max_integrity

func get_current_health():
	return current_health

func get_current_fuel():
	return fuel

func add_item_to_collected_itens(item : Junk):
	if (item.size < PlayerStatus.max_storage - current_collected_itens_used_space ):
		current_collected_itens_used_space += item.size
		collected_itens.append(item)
		return true
	else:
		return false

func get_collected_itens():
	return collected_itens
	
func set_collected_itens(itens):
	collected_itens = itens
