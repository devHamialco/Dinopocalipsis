extends Control

@onready var click: AudioStreamPlayer = $click
@onready var hover: AudioStreamPlayer = $hover
var game_manager: Node = null

func _ready() -> void:
	# Mostrar cursor para menús UI
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	game_manager = get_node_or_null("/root/GameManager")

	# Reproducir música si es la escena de selección de niveles o menú
	var music_manager = get_node_or_null("/root/MusicManager")
	if music_manager:
		var scene_path = get_scene_file_path()
		if "niveles" in scene_path or "menu" in scene_path or "instrucciones" in scene_path:
			var menu_music = preload("res://Music/menu.mp3")
			music_manager.play_menu_music(menu_music)

	_connect_button("Regresar", _on_regresar_pressed)
	_connect_button("Menú", _on_menu_pressed)
	_connect_button("Play")  # Ya conectado en la escena
	_connect_button("TextureRect2/Nivel1", _on_nivel1_pressed)
	_connect_button("TextureRect2/Nivel2", _on_nivel2_pressed)
	_connect_button("TextureRect2/Nivel3", _on_nivel3_pressed)

	# Foco inicial para navegación con joystick
	var scene_path = get_scene_file_path()
	if "niveles" in scene_path:
		var first_level = get_node_or_null("TextureRect2/Nivel1")
		if first_level:
			first_level.grab_focus()
	else:
		var back_btn = get_node_or_null("Regresar")
		if back_btn:
			back_btn.grab_focus()

func _connect_button(path: String, callback: Callable = Callable()) -> void:
	var btn = get_node_or_null(path)
	if btn:
		btn.mouse_entered.connect(_play_hover_sound)
		btn.focus_entered.connect(_play_hover_sound)
		# Mismo estilo hover para el foco (joystick)
		var hover_style = btn.get("theme_override_styles/hover")
		if hover_style:
			btn.set("theme_override_styles/focus", hover_style)
		if callback.is_valid() and not btn.pressed.is_connected(callback):
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
