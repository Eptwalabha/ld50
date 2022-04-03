extends Node

signal fov_changed(fov)
signal crosshair_visibility_changed(visible)
signal gamma_changed(gamma)
signal load_config(config)

const GameConfig = preload("res://save-system/GameConfig.gd")

const DEBUG : bool = false
const DEBUG_ENVIRONMENT : bool = false

const FOV_MIN : int = 40
const FOV_MAX : int = 140
var PLAYER_FOV : int = 90

const MOUSE_SENSITIVITY_MIN : float = 0.3
const MOUSE_SENSITIVITY_MAX : float = 1.5
var MOUSE_SENSITIVITY : float = 1.0
var MOUSE_INVERT_Y : bool = false

var CROSSHAIR_VISIBLE : bool = true

const BUS_VOLUME_MIN : float = -24.0
const BUS_VOLUME_MAX : float = 7.0

const GRAVITY : int = 10
const MAX_GRAVITY : int = 100
const MAX_SLOP : float = deg2rad(15.0)

const JUMP_HIGHT : float = 4.5

var first_time : bool = true
var using_controller : bool = true

var scarcity : float = 0.5
var initial_cash : int = 100
var player_cash : int = 100
var money_per_day : int = 20
var day : int = 1

enum INPUT_TYPE {
	KEY,
	MOUSE
}

const KEYBOARD_DISPOSITIONS = {
	"QWERTY": [KEY_W, KEY_A, KEY_S, KEY_D, KEY_SPACE, KEY_E],
	"AZERTY": [KEY_Z, KEY_Q, KEY_S, KEY_D, KEY_SPACE, KEY_E],
	"BÉPO": [233, KEY_A, KEY_U, KEY_I, KEY_SPACE, KEY_P]
}
const ARROW_MAPPING = [KEY_UP, KEY_LEFT, KEY_DOWN, KEY_RIGHT, null, KEY_ENTER]
const MAPPING_ACTIONS = [
	"move_forward", "move_left", "move_backward", "move_right", "move_jump", "context_action"
]

var KEYBOARD_MAPPING = "QWERTY"

var WIDTH_RESOLUTIONS = [
	800, 1024, 1280, 1334, 1400, 1440, 1600, 1900, 1920, 2048, 2560, 3440
]

var SCREEN_RATIOS = [
	Vector2(1, 1),
	Vector2(3, 2),
	Vector2(4, 3),
	Vector2(16, 9),
	Vector2(21, 9)
]

var AVAILABLE_LOCALS = [
	"en",
	"fr"
]

const MAX_DB : float = 5.0
const MIN_DB : float = -20.0

var current_config : GameConfig

enum GROCERY_ITEMS {
	CAN_OF_SOUP,
	BOX_OF_CEREAL,
	MEAT,
	SODA_1,
	SODA_2,
	COFEE,
	TOILETTE_PAPER,
	SNACK_1,
	SNACK_2,
	INSTANT_NOODLE,
	FRUIT,
	VEGETABLE,
	SUGAR
}

const LEVELS = {
	"lvl_1": {
		"list": [
			[GROCERY_ITEMS.FRUIT, 2],
			[GROCERY_ITEMS.VEGETABLE, 2],
			[GROCERY_ITEMS.MEAT, 1],
			[GROCERY_ITEMS.CAN_OF_SOUP, 1],
			[GROCERY_ITEMS.TOILETTE_PAPER, 1]
		],
		"promotion": 1,
		"disturbance": 0
	},
	"lvl_2": {
		"list": [
			[GROCERY_ITEMS.FRUIT, 2],
			[GROCERY_ITEMS.MEAT, 2],
			[GROCERY_ITEMS.BOX_OF_CEREAL, 2],
			[GROCERY_ITEMS.COFEE, 1],
			[GROCERY_ITEMS.INSTANT_NOODLE, 1],
			[GROCERY_ITEMS.TOILETTE_PAPER, 1],
			[GROCERY_ITEMS.SNACK_1, 1],
		],
		"promotion": 2,
		"disturbance": 0
	},
	"lvl_3": {
		"list": [
			[GROCERY_ITEMS.SODA_1, 1],
			[GROCERY_ITEMS.BOX_OF_CEREAL, 3],
			[GROCERY_ITEMS.VEGETABLE, 1],
			[GROCERY_ITEMS.MEAT, 2],
			[GROCERY_ITEMS.CAN_OF_SOUP, 1],
			[GROCERY_ITEMS.COFEE, 2],
			[GROCERY_ITEMS.SUGAR, 1],
			[GROCERY_ITEMS.TOILETTE_PAPER, 1],
			[GROCERY_ITEMS.SNACK_2, 1],
		],
		"promotion": 3,
		"disturbance": 1
	},
	"lvl_4": {
		"list": [
			[GROCERY_ITEMS.SODA_2, 1],
			[GROCERY_ITEMS.BOX_OF_CEREAL, 3],
			[GROCERY_ITEMS.MEAT, 3],
			[GROCERY_ITEMS.INSTANT_NOODLE, 3],
			[GROCERY_ITEMS.COFEE, 3],
			[GROCERY_ITEMS.SUGAR, 2],
			[GROCERY_ITEMS.TOILETTE_PAPER, 1],
			[GROCERY_ITEMS.SNACK_1, 1],
			[GROCERY_ITEMS.SNACK_2, 2],
		],
		"promotion": 4,
		"disturbance": 2
	},
	"lvl_5": {
		"list": [
			[GROCERY_ITEMS.SODA_1, 3],
			[GROCERY_ITEMS.SODA_2, 3],
			[GROCERY_ITEMS.MEAT, 5],
			[GROCERY_ITEMS.COFEE, 1],
			[GROCERY_ITEMS.BOX_OF_CEREAL, 4],
			[GROCERY_ITEMS.TOILETTE_PAPER, 3],
			[GROCERY_ITEMS.SNACK_1, 2],
			[GROCERY_ITEMS.SNACK_2, 3],
		],
		"promotion": 5,
		"disturbance": 3
	},
	"lvl_6": {
		"list": [],
		"count-down": false,
		"promotion": 0,
		"disturbance": 4
	}
}
var current_level = 0

func _ready() -> void:
	current_config = load_config()
	apply_config(current_config)

func save_config(_config: GameConfig) -> void:
	ResourceSaver.save("user://game-config.tres", get_config())

func load_config() -> GameConfig:
	var path : String = "user://game-config.tres"
	var config : GameConfig = GameConfig.new()
	if ResourceLoader.exists(path):
		config = ResourceLoader.load(path)
		config.update_config_version()
	else:
		config = get_config()
	return config

func apply_config(config: GameConfig) -> void:
	OS.window_fullscreen = config.data['fullscreen']
	set_screen_resolution(config.data['screen_resolution'])
	set_bus_volume('Master', config.data['bus_master'])
	set_bus_volume('Music', config.data['bus_music'])
	set_bus_volume('Sfx', config.data['bus_sfx'])
	CROSSHAIR_VISIBLE = config.data['crosshair_visible']
	PLAYER_FOV = config.data['player_fov']
	set_vsync(config.data['vsync_on'])
	set_language(config.data['language'])
	MOUSE_SENSITIVITY = config.data['mouse_sensitivity']
	MOUSE_INVERT_Y = config.data['mouse_invert_y']
	set_keyboard_mapping(config.data['mapping'])

func get_config() -> GameConfig:
	var config : GameConfig = GameConfig.new()
	config.version = ProjectSettings.get("application/config/version")
	config.data = {
		'fullscreen': OS.window_fullscreen,
		'screen_resolution': Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height")),
		'bus_master': get_volume_percent('Master'),
		'bus_music': get_volume_percent('Music'),
		'bus_sfx': get_volume_percent('Sfx'),
		'crosshair_visible': CROSSHAIR_VISIBLE,
		'player_fov': PLAYER_FOV,
		'vsync_on': OS.vsync_enabled,
		'language': TranslationServer.get_locale(),
		'mouse_sensitivity': MOUSE_SENSITIVITY,
		'mouse_invert_y': MOUSE_INVERT_Y,
		'mapping': KEYBOARD_MAPPING
	}
	return config

func set_language(language: String) -> void:
	TranslationServer.set_locale(language)

func set_fullscreen(fullscreen: bool) -> void:
	OS.window_fullscreen = fullscreen

func set_screen_resolution(resolution: Vector2) -> void:
	if OS.window_fullscreen:
		get_viewport().size = resolution
	else:
		OS.window_size = resolution

func get_screen_resolution() -> Vector2:
	if OS.window_fullscreen:
		return get_viewport().size
	return OS.window_size

func set_bus_volume(bus_name: String, volume: float) -> void:
	var bus_index : int = AudioServer.get_bus_index(bus_name)
	if volume > 0.0:
		AudioServer.set_bus_mute(bus_index, false)
		var db = min(lerp(MIN_DB, MAX_DB, volume), MAX_DB)
		AudioServer.set_bus_volume_db(bus_index, db)
	else:
		AudioServer.set_bus_mute(bus_index, true)

func get_volume_percent(bus_name: String) -> float:
	var bus_index : int = AudioServer.get_bus_index(bus_name)
	if AudioServer.is_bus_mute(bus_index):
		return 0.0
	else:
		var db = AudioServer.get_bus_volume_db(bus_index)
		return inverse_lerp(MIN_DB, MAX_DB, db)

func set_mouse_sensitivity(value: float) -> void:
	MOUSE_SENSITIVITY = lerp(MOUSE_SENSITIVITY_MIN, MOUSE_SENSITIVITY_MAX, value)

func get_mouse_sensitivity_value() -> float:
	return inverse_lerp(MOUSE_SENSITIVITY_MIN, MOUSE_SENSITIVITY_MAX, MOUSE_SENSITIVITY)

func set_mouse_invert_y(inverted: bool) -> void:
	MOUSE_INVERT_Y = inverted

func get_mouse_invert_y_value() -> String:
	return "true" if MOUSE_INVERT_Y else "false"

func set_crosshair_visibility(visible: bool) -> void:
	CROSSHAIR_VISIBLE = visible
	emit_signal("crosshair_visibility_changed", visible)

func get_crosshair_visibility_value() -> String:
	return "true" if CROSSHAIR_VISIBLE else "false"

func set_player_fov(value: float) -> void:
	PLAYER_FOV = lerp(FOV_MIN, FOV_MAX, value)
	emit_signal("fov_changed", PLAYER_FOV)

func get_player_fov_value() -> float:
	return inverse_lerp(FOV_MIN, FOV_MAX, PLAYER_FOV)

func set_vsync(use_vsync: bool) -> void:
	OS.vsync_enabled = use_vsync

func get_vsync_value() -> String:
	return "true" if OS.vsync_enabled else "false"

func set_keyboard_mapping(keyboard_type: String) -> void:
	for disposition in KEYBOARD_DISPOSITIONS:
		if disposition == keyboard_type:
			KEYBOARD_MAPPING = keyboard_type
	update_keyboard_input()

func update_keyboard_input() -> void:
	var mapping = KEYBOARD_DISPOSITIONS[KEYBOARD_MAPPING]
	for i in range(len(MAPPING_ACTIONS)):
		var action = MAPPING_ACTIONS[i]
		for input in InputMap.get_action_list(action):
			if input is InputEventKey:
				InputMap.action_erase_event(action, input)
		var new_input = InputEventKey.new()
		new_input.scancode = mapping[i]
		InputMap.action_add_event(action, new_input)
		if ARROW_MAPPING[i] != null:
			var arrow_input = InputEventKey.new()
			arrow_input.scancode = ARROW_MAPPING[i]
			InputMap.action_add_event(action, arrow_input)

func get_scancode_for(action) -> int:
	var mapping = KEYBOARD_DISPOSITIONS[KEYBOARD_MAPPING]
	var i = MAPPING_ACTIONS.find(action)
	return mapping[i]
