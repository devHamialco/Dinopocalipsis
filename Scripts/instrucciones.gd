extends Control

@onready var click: AudioStreamPlayer = $click
@onready var hover: AudioStreamPlayer = $hover
var game_manager: Node = null

func _ready() -> void:
	# Mostrar cursor para menús UI
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	game_manager = get_node_or_null("/root/GameManager")
	_connect_button("Regresar", _on_regresar_pressed)
	_connect_button("Menú", _on_menu_pressed)
	_connect_button("Play")  # Ya conectado en la escena
	_connect_button("TextureRect2/Nivel1", _on_nivel1_pressed)
	_connect_button("TextureRect2/Nivel2", _on_nivel2_pressed)
	_connect_button("TextureRect2/Nivel3", _on_nivel3_pressed)

func _connect_button(path: String, callback: Callable = Callable()) -> void:
	var btn = get_node_or_null(path)
	if btn:
		btn.mouse_entered.connect(_play_hover_sound)
		if callback.is_valid():
			btn.pressed.connect(callback)

func _play_button_sound() -> void:
	if click:
		click.play()

func _play_hover_sound() -> void:
	if hover:
		hover.play()

func _on_regresar_pressed() -> void:
	_play_button_sound()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Escenas/menu.tscn")

func _on_menu_pressed() -> void:
	_play_button_sound()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://Escenas/menu.tscn")

func _on_reintentar_pressed() -> void:
	_play_button_sound()
	await get_tree().create_timer(0.1).timeout
	var level = ""
	if game_manager:
		level = game_manager.current_level
	if level != "":
		get_tree().change_scene_to_file(level)
	else:
		get_tree().change_scene_to_file("res://Escenas/nivel_1.tscn")

func _on_nivel1_pressed() -> void:
	_play_button_sound()
	await get_tree().create_timer(0.1).timeout
	if game_manager:
		game_manager.current_level = "res://Escenas/nivel_1.tscn"
	get_tree().change_scene_to_file("res://Escenas/nivel_1.tscn")

func _on_nivel2_pressed() -> void:
	_play_button_sound()
	await get_tree().create_timer(0.1).timeout
	if game_manager:
		game_manager.current_level = "res://Escenas/nivel_2.tscn"
	get_tree().change_scene_to_file("res://Escenas/nivel_2.tscn")

func _on_nivel3_pressed() -> void:
	_play_button_sound()
	await get_tree().create_timer(0.1).timeout
	if game_manager:
		game_manager.current_level = "res://Escenas/nivel_3.tscn"
	get_tree().change_scene_to_file("res://Escenas/nivel_3.tscn")
