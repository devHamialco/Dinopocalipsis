extends CharacterBody3D

var curHp: int = 3
var maxHp: int = 3

var damage: int = 1
var attackDist: float = 1.5
var attackRate: float = 1.0

var moveSpeed: float = 4.5
var vel: Vector3 = Vector3.ZERO 
var jumpVelocity: float = 5.0
var canJump: bool = true
var gravity: float = 15.0

@onready var timer = $Timer
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
var player: Node3D

func _ready() -> void:
	timer.wait_time = attackRate
	timer.start()
	player = get_tree().get_nodes_in_group("player")[0]
	nav_agent.path_desired_distance = 0.5
	nav_agent.target_desired_distance = 0.5

func _physics_process(_delta: float) -> void:
	if not is_instance_valid(player):
		velocity = Vector3.ZERO
		move_and_slide()
		return
	
	var direction = (player.global_position - global_position).normalized()
	direction.y = 0
	
	velocity.x = direction.x * moveSpeed
	velocity.z = direction.z * moveSpeed
	velocity.y -= gravity * _delta
	
	if is_on_wall() and is_on_floor() and canJump:
		velocity.y = jumpVelocity
		canJump = false
		get_tree().create_timer(1.0).timeout.connect(func(): canJump = true)
	
	move_and_slide()


func _on_Timer_timeout() -> void:
	if not is_instance_valid(player):
		return
	var player_pos_horizontal = Vector3(player.global_position.x, global_position.y, player.global_position.z)
	if global_transform.origin.distance_to(player_pos_horizontal) <= attackDist:
		player.take_damage(damage)  

func die() -> void:
	queue_free()
