extends CharacterBody3D

var curHp: int = 3
var maxHp: int = 3

var damage: float = 1.0
var attackRate: float = 1.0

var moveSpeed: float = 4.5
var vel: Vector3 = Vector3.ZERO 
var jumpVelocity: float = 5.0
var canJump: bool = true
var gravity: float = 15.0

@onready var attack_cooldown = $AttackCooldown
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var attack_area: Area3D = $AttackArea
var player: Node3D
var can_attack: bool = true

@export var flap_speed: float = 4.0
@export var flap_amount: float = 0.3

@onready var wing_flap_shader: Shader = preload("res://Recursos/wing_flap.gdshader")

func _ready() -> void:
	attack_cooldown.wait_time = attackRate
	attack_cooldown.one_shot = true
	attack_cooldown.timeout.connect(_on_attack_cooldown_finished)
	
	attack_area.body_entered.connect(_on_attack_area_entered)
	
	player = get_tree().get_nodes_in_group("player")[0]
	nav_agent.path_desired_distance = 0.5
	nav_agent.target_desired_distance = 0.5
	
	_apply_wing_flap_shader()

func _apply_wing_flap_shader() -> void:
	for child in $Pterablocktyls.get_children():
		if child is MeshInstance3D and child.mesh:
			# Crear un ShaderMaterial POR CADA SURFACE (los ojos pueden estar
			# en surfaces secundarias del mismo mesh)
			for surface in range(child.mesh.get_surface_count()):
				var existing = child.get_surface_override_material(surface)
				if existing == null:
					existing = child.mesh.surface_get_material(surface)
				
				var shader_mat = ShaderMaterial.new()
				shader_mat.shader = wing_flap_shader
				
				if existing and existing is BaseMaterial3D:
					var tex = existing.albedo_texture
					if tex:
						shader_mat.set_shader_parameter("albedo_texture", tex)
					shader_mat.set_shader_parameter("albedo_color", existing.albedo_color)
					shader_mat.set_shader_parameter("roughness", existing.roughness)
					shader_mat.set_shader_parameter("metallic", existing.metallic)
					if existing.emission_enabled:
						shader_mat.set_shader_parameter("emission", existing.emission)
						shader_mat.set_shader_parameter("emission_energy", existing.emission_energy_multiplier)
				
				# Pasar parámetros de aleteo a cada surface
				shader_mat.set_shader_parameter("flap_speed", flap_speed)
				shader_mat.set_shader_parameter("flap_amount", flap_amount)
				
				child.set_surface_override_material(surface, shader_mat)

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(player):
		velocity = Vector3.ZERO
		move_and_slide()
		return
	
	var head_pos = player.global_position
	if player.has_method("get_head_target"):
		head_pos = player.get_head_target()
	
	var direction = (head_pos - global_position).normalized()
	direction.y = 0
	
	velocity.x = direction.x * moveSpeed
	velocity.z = direction.z * moveSpeed
	velocity.y -= gravity * _delta
	
	if is_on_wall() and is_on_floor() and canJump:
		velocity.y = jumpVelocity
		canJump = false
		get_tree().create_timer(1.0).timeout.connect(func(): canJump = true)
	
	look_at(Vector3(head_pos.x, global_position.y, head_pos.z))
	move_and_slide()

func _on_attack_area_entered(body: Node3D) -> void:
	if body.is_in_group("player") and can_attack:
		print("Enemigo colisiona con player! Aplicando daño: ", damage)
		can_attack = false
		attack_cooldown.start()
		if body.has_method("take_damage"):
			body.take_damage(damage)
			print("Daño aplicado correctamente")
		else:
			print("ERROR: player no tiene metodo take_damage")

func _on_attack_cooldown_finished() -> void:
	can_attack = true
	print("Cooldown terminado, enemigo puede atacar de nuevo")

func die() -> void:
	queue_free()
