extends HBoxContainer

func _ready() -> void:
	var game_manager = get_node_or_null("/root/GameManager")
	if not game_manager:
		return
		
	# Determine which level this container is for based on node name
	# e.g., "Starsnivel1" -> "nivel_1"
	var level_num = name.replace("Starsnivel", "")
	var level_key = "nivel_" + level_num
	
	var rating = game_manager.get_rating(level_key)
	
	# Update the existing TextureProgressBar children
	for i in range(get_child_count()):
		var bar = get_child(i)
		if bar is TextureProgressBar:
			bar.value = 1.0 if i < rating else 0.0
