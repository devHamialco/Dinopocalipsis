extends Node

var music_player: AudioStreamPlayer

func _ready() -> void:
	# Crea el reproductor de música
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.volume_db = -25
	# Configura para que se repita
	music_player.finished.connect(_on_music_finished)

func play_menu_music(music_stream: AudioStream) -> void:
	# Solo reproduce si no está sonando ya
	if music_player.stream != music_stream or not music_player.playing:
		music_player.stream = music_stream
		music_player.play()

func stop_music() -> void:
	music_player.stop()

func _on_music_finished() -> void:
	music_player.play()  # Repite la música
