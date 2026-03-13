extends Control
@onready var click: AudioStreamPlayer = $VBoxContainer/Play/click
@onready var hover: AudioStreamPlayer = $VBoxContainer/hover
@onready var background_music: AudioStream = preload("res://Music/menu.mp3")  # Ajusta la ruta

func _ready() -> void:
	# Inicia la música del menú
	MusicManager.play_menu_music(background_music)
	
	# Conecta automáticamente todos los botones del VBoxContainer
	for child in $VBoxContainer.get_children():
		if child is Button:
			child.pressed.connect(_play_button_sound)
			child.mouse_entered.connect(_play_hover_sound)

func _play_button_sound() -> void:
	click.play()

func _play_hover_sound() -> void:
	hover.play()

func _on_play_pressed() -> void:
	await click.finished
	MusicManager.stop_music()  # Detiene la música al iniciar el juego
	get_tree().change_scene_to_file("res://Escenas/nivel_1.tscn")

func _on_instrucciones_pressed() -> void:
	await click.finished
	get_tree().change_scene_to_file("res://Escenas/instrucciones.tscn")

func _on_creditos_pressed() -> void:
	await click.finished
	get_tree().change_scene_to_file("res://Escenas/creditos.tscn")

func _on_quit_pressed() -> void:
	await click.finished
	get_tree().quit()
