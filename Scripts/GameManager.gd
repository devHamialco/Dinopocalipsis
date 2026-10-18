extends Node

var current_level: String = ""
var star_ratings: Dictionary = {}

func _ready() -> void:
	_load_ratings()
	_setup_controller()

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

func _setup_controller() -> void:
	# Mapea joystick izquierdo a ui_left/right/up/down y botón A a ui_accept
	# Solo agrega si no tienen ya eventos de gamepad
	for action in ["ui_left", "ui_right", "ui_up", "ui_down", "ui_accept", "ui_cancel"]:
		var has_joy = false
		for event in InputMap.action_get_events(action):
			if event is InputEventJoypadButton or event is InputEventJoypadMotion:
				has_joy = true
				break
		if has_joy:
			continue

		match action:
			"ui_left":
				var ev = InputEventJoypadMotion.new()
				ev.axis = JOY_AXIS_LEFT_X
				ev.axis_value = -1.0
				InputMap.action_add_event(action, ev)
			"ui_right":
				var ev = InputEventJoypadMotion.new()
				ev.axis = JOY_AXIS_LEFT_X
				ev.axis_value = 1.0
				InputMap.action_add_event(action, ev)
			"ui_up":
				var ev = InputEventJoypadMotion.new()
				ev.axis = JOY_AXIS_LEFT_Y
				ev.axis_value = -1.0
				InputMap.action_add_event(action, ev)
			"ui_down":
				var ev = InputEventJoypadMotion.new()
				ev.axis = JOY_AXIS_LEFT_Y
				ev.axis_value = 1.0
				InputMap.action_add_event(action, ev)
			"ui_accept":
				var ev = InputEventJoypadButton.new()
				ev.button_index = JOY_BUTTON_A
				InputMap.action_add_event(action, ev)
			"ui_cancel":
				var ev = InputEventJoypadButton.new()
				ev.button_index = JOY_BUTTON_B
				InputMap.action_add_event(action, ev)
