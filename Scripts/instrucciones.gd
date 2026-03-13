extends Control
@onready var click: AudioStreamPlayer = $click
@onready var hover: AudioStreamPlayer = $hover

func _ready() -> void:
	# Conecta el botón regresar a los sonidos
	$Regresar.mouse_entered.connect(_play_hover_sound)
	$Regresar.pressed.connect(_play_button_sound)

func _play_button_sound() -> void:
	click.play()

func _play_hover_sound() -> void:
	hover.play()

func _on_regresar_pressed() -> void:
	await click.finished
	get_tree().change_scene_to_file("res://Escenas/menu.tscn")
