extends Node

var music_player: AudioStreamPlayer

func _ready() -> void:
	# Crea el reproductor de música
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.volume_db = -1
	# Configura para que se repita
	music_player.finished.connect(_on_music_finished)

func play_menu_music(music_stream: AudioStream) -> void:
	# Solo reproduce si no está sonando ya
	if not music_player.playing:
		music_player.stream = music_stream
		music_player.play()

func play_level_music(level_key: String) -> void:
	var path = "res://Music/" + level_key + ".mp3"
	var stream = load(path)
	if stream:
		music_player.stream = stream
		music_player.play()

func play_win_sound() -> void:
	var win = load("res://Music/win.wav")
	if win:
		music_player.stop()  # No superponer con música de fondo
		var sfx = AudioStreamPlayer.new()
		_add_sfx_to_scene(sfx)
		sfx.stream = win
		sfx.finished.connect(sfx.queue_free)
		sfx.play()

func play_lose_sound() -> void:
	var lose = load("res://Music/lose.wav")
	if lose:
		music_player.stop()  # No superponer con música de fondo
		var sfx = AudioStreamPlayer.new()
		_add_sfx_to_scene(sfx)
		sfx.stream = lose
		sfx.volume_db = -1
		sfx.finished.connect(sfx.queue_free)
		sfx.play()

# Agrega el SFX a la escena actual para que se libere al cambiar de escena
func _add_sfx_to_scene(sfx: AudioStreamPlayer) -> void:
	var current = get_tree().current_scene
	if current:
		current.add_child(sfx)
	else:
		add_child(sfx)  # fallback: que lo limpie queue_free

func stop_music() -> void:
	music_player.stop()

func _on_music_finished() -> void:
	music_player.play()  # Repite la música
