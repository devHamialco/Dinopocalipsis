extends CharacterBody3D

const SPEED = 5.3
const JUMP_VELOCITY = 4.5

# Sensibilidad del mouse
const MOUSE_SENSITIVITY = 0.003

# Referencia al SpringArm
@onready var spring_arm = $SpringArm3D  # Ajusta la ruta según tu escena

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	add_to_group("player")
	
func _input(event: InputEvent) -> void:
	# Capturar el movimiento del mouse
	if event is InputEventMouseMotion:
		# Rotar el personaje horizontalmente (eje Y)
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		
		# Rotar la cámara verticalmente (eje X) usando el SpringArm
		spring_arm.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		
		# Limitar la rotación vertical para evitar que se voltee completamente
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _process(_delta: float) -> void:
	# Liberar/capturar el mouse con ESC
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
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
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
