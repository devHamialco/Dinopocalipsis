extends Node3D

@onready var player: CharacterBody3D = $Player
var game_manager: Node = null

func _ready() -> void:
	game_manager = get_node_or_null("/root/GameManager")
	var music_manager = get_node_or_null("/root/MusicManager")

	# Conectar victoria al player — cuando recolecta todos los 25 huevos
	if player and player.has_signal("victory"):
		player.victory.connect(_on_all_eggs_collected)

	# Set current level in GameManager
	var scene_path = get_scene_file_path()
	if scene_path != "" and game_manager:
		game_manager.current_level = scene_path

	# Reproducir música del nivel
	if music_manager:
		var level_num = "1"
		if "nivel_1" in scene_path:
			level_num = "1"
		elif "nivel_2" in scene_path:
			level_num = "2"
		elif "nivel_3" in scene_path:
			level_num = "3"
		music_manager.play_level_music(level_num)

	# Listen for player death events
	if player and player.has_signal("player_died"):
		player.player_died.connect(_on_player_died)
	if player and player.has_signal("death_animation_finished"):
		player.death_animation_finished.connect(_on_death_animation_finished)

func _on_all_eggs_collected() -> void:
	if not game_manager or not is_instance_valid(game_manager):
		return

	# Reproducir sonido de victoria
	var music_manager = get_node_or_null("/root/MusicManager")
	if music_manager:
		music_manager.play_win_sound()

	player.is_alive = false
	player.set_process(false)
	player.set_process_input(false)
	player.set_physics_process(false)

	# Stars = current_health (0-5). Cada 1.0 de health = 1 estrella
	var stars = int(player.current_health)

	# Determinar level_key del path de la escena
	var scene_path = get_scene_file_path()
	var level_key = "nivel_1"
	if "nivel_1" in scene_path:
		level_key = "nivel_1"
	elif "nivel_2" in scene_path:
		level_key = "nivel_2"
	elif "nivel_3" in scene_path:
		level_key = "nivel_3"

	var current_rating = game_manager.get_rating(level_key)
	if stars > current_rating:
		game_manager.save_rating(level_key, stars)
		print("NIVEL COMPLETADO! Nueva calificación: ", stars, " estrellas para ", level_key)

	# Pequeña pausa para que se vea el último frame
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Escenas/niveles.tscn")

func _on_player_died(_health: float) -> void:
	# Reproducir sonido de game over
	var music_manager = get_node_or_null("/root/MusicManager")
	if music_manager:
		music_manager.play_lose_sound()

func _on_death_animation_finished() -> void:
	# Cargar gameover como overlay encima del nivel
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 10
	var gameover = load("res://Escenas/gameover.tscn").instantiate()
	canvas_layer.add_child(gameover)
	add_child(canvas_layer)
