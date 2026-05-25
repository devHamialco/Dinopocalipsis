extends Node3D

@onready var player: CharacterBody3D = $Player
var game_manager: Node = null

func _ready() -> void:
	game_manager = get_node_or_null("/root/GameManager")
	
	_connect_all_eggs()
	
	# Set current level in GameManager
	var scene_path = get_scene_file_path()
	if scene_path != "" and game_manager:
		game_manager.current_level = scene_path
	
	# Listen for player death events
	if player and player.has_signal("player_died"):
		player.player_died.connect(_on_player_died)
	if player and player.has_signal("death_animation_finished"):
		player.death_animation_finished.connect(_on_death_animation_finished)

func _connect_all_eggs() -> void:
	for huevo in get_tree().get_nodes_in_group("huevos"):
		if huevo.has_signal("collectado"):
			huevo.collectado.connect(_on_egg_collected)

func _on_egg_collected(_valor: int) -> void:
	if player and player.has_method("collect_egg"):
		player.collect_egg()

func _on_player_died(health: float) -> void:
	# Calculate stars: health is 0-5, each 1.0 = 1 star
	var stars = int(health)
	
	# Determine level key from scene path
	var scene_path = get_scene_file_path()
	var level_key = "nivel_1"  # default
	if "nivel_1" in scene_path:
		level_key = "nivel_1"
	elif "nivel_2" in scene_path:
		level_key = "nivel_2"
	elif "nivel_3" in scene_path:
		level_key = "nivel_3"
	
	# Only save if this is better than existing rating
	if game_manager:
		var current_rating = game_manager.get_rating(level_key)
		if stars > current_rating:
			game_manager.save_rating(level_key, stars)
			print("Nueva calificacion guardada: ", stars, " estrellas para ", level_key)

func _on_death_animation_finished() -> void:
	# Cargar gameover como overlay encima del nivel
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 10
	var gameover = load("res://Escenas/gameover.tscn").instantiate()
	canvas_layer.add_child(gameover)
	add_child(canvas_layer)
