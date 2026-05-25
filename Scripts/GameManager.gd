extends Node

var current_level: String = ""
var star_ratings: Dictionary = {}

func _ready() -> void:
	_load_ratings()

func _load_ratings() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://ratings.cfg")
	if err == OK:
		star_ratings = {
			"nivel_1": config.get_value("ratings", "nivel_1", 0),
			"nivel_2": config.get_value("ratings", "nivel_2", 0),
			"nivel_3": config.get_value("ratings", "nivel_3", 0)
		}
	else:
		star_ratings = {"nivel_1": 0, "nivel_2": 0, "nivel_3": 0}

func save_rating(level: String, stars: int) -> void:
	star_ratings[level] = stars
	var config = ConfigFile.new()
	for key in star_ratings:
		config.set_value("ratings", key, star_ratings[key])
	config.save("user://ratings.cfg")

func get_rating(level: String) -> int:
	return star_ratings.get(level, 0)
