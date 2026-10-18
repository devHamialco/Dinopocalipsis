extends CharacterBody3D

signal player_died(health: float)
signal death_animation_finished()
signal victory()

const SPEED = 8
const JUMP_VELOCITY = 4.5

# Sensibilidad del mouse
const MOUSE_SENSITIVITY = 0.003

# Vida
const MAX_HEALTH: float = 5.0
const HEALTH_PER_EGG: float = 1.0
const HEALTH_PER_HIT: float = 1.0

var huevos_collected: int = 0
var current_health: float = 0.0
var is_alive: bool = true
var has_had_health: bool = false  # Para evitar muerte al inicio del juego

# Referencias
@onready var spring_arm = $SpringArm3D
@onready var anim_player = $Trex/AnimationPlayer
var health_bar: TextureProgressBar = null

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	add_to_group("player")
	current_health = 0.0
	is_alive = true
	has_had_health = false

	# Find health bar from instanced progresbar scene
	var canvas = get_node_or_null("Barra de vida")
	if canvas:
		health_bar = canvas.find_child("TextureProgressBar", true, false)
	_update_health_bar()

func _input(event: InputEvent) -> void:
	if not is_alive:
		return

	# Capturar el movimiento del mouse
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		spring_arm.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _process(delta: float) -> void:
	# Liberar/capturar el mouse con ESC
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Joystick derecho: rotación horizontal continua (solo en niveles)
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and Input.get_connected_joypads().size() > 0:
		var right_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
		if abs(right_x) > 0.15:
			rotate_y(-right_x * MOUSE_SENSITIVITY * 12.0)

func _physics_process(delta: float) -> void:
	if not is_alive:
		velocity = Vector3.ZERO
		move_and_slide()
		return

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		# Animación de correr (solo si está en el suelo y no está saltando)
		if is_on_floor() and anim_player and anim_player.current_animation != "Armature|TRex_Run":
			anim_player.play("Armature|TRex_Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func collect_egg() -> void:
	if not is_alive:
		return

	huevos_collected += 1
	print("Egg collected! Total: ", huevos_collected, " Health: ", current_health)
	if huevos_collected % 5 == 0:
		current_health = min(current_health + HEALTH_PER_EGG, MAX_HEALTH)
		has_had_health = true  # Marcamos que ya tuvo vida
		print("Health increased to: ", current_health)
		_update_health_bar()

	# Victória si se recolectaron todos los 25 huevos
	if huevos_collected >= 25:
		victory.emit()

func take_damage(amount: float) -> void:
	if not is_alive:
		return

	print("Player recibe daño! Amount: ", amount, " Health before: ", current_health)
	current_health = max(current_health - amount, 0.0)
	print("Health after damage: ", current_health)
	_update_health_bar()

	# Verificar si murió (solo si ya había tenido vida antes)
	if current_health <= 0.0 and has_had_health:
		die()

func die() -> void:
	if not is_alive:
		return

	is_alive = false
	player_died.emit(current_health)
	print("PLAYER HA MUERTO - Reproduciendo animación de muerte")

	# Desactivar controles
	set_process_input(false)
	set_physics_process(false)
	set_process(false)

	# Reproducir animación de muerte
	if anim_player:
		anim_player.play("Armature|TRex_Death")
		# Esperar a que termine la animación y luego mostrar game over
		await anim_player.animation_finished
		print("Animación de muerte completada")
		death_animation_finished.emit()

func get_head_target() -> Vector3:
	# Devuelve la posición global del hueso Head en el esqueleto
	var skeleton = $Trex/Armature/Skeleton3D
	if skeleton:
		var head_idx = skeleton.find_bone("Head")
		if head_idx >= 0:
			var world_pos = (skeleton.global_transform * skeleton.get_bone_global_pose(head_idx)).origin
			return world_pos
	# Fallback: un poco arriba del cuerpo
	return global_position + Vector3.UP * 1.5

func get_tail_target() -> Vector3:
	# Devuelve la posición global del hueso Tail5 (punta de la cola)
	var skeleton = $Trex/Armature/Skeleton3D
	if skeleton:
		var tail_idx = skeleton.find_bone("Tail5")
		if tail_idx >= 0:
			var world_pos = (skeleton.global_transform * skeleton.get_bone_global_pose(tail_idx)).origin
			return world_pos
	# Fallback: detrás del T-Rex
	return global_position + transform.basis.z * 2.0

func _update_health_bar() -> void:
	if health_bar:
		health_bar.value = current_health
