extends Node

signal fov_changed(fov)
signal crosshair_visibility_changed(visible)
signal gamma_changed(gamma)

const GameConfig = preload("res://save-system/GameConfig.gd")

const DEBUG : bool = true
const DEBUG_ENVIRONMENT : bool = false

const GAMMA_MAX : float = 0.8
const GAMMA_MIN : float = 2.0
const FOV_MIN : int = 40
const FOV_MAX : int = 140
const MOUSE_SENSITIVITY_MIN : float = 0.3
const MOUSE_SENSITIVITY_MAX : float = 1.5
var MOUSE_SENSITIVITY : float = 1.0
var INVERT_Y : bool = false

const BUS_VOLUME_MIN : float = -24.0
const BUS_VOLUME_MAX : float = 7.0

const GRAVITY : int = 10
const MAX_GRAVITY : int = 100
const MAX_SLOP : float = deg2rad(15.0)

const JUMP_HIGHT : float = 4.5

var scarcity : float = 0.5
var first_time : bool = true
var using_controller : bool = true

enum INPUT_TYPE {
	KEY,
	MOUSE
}

const default_mapping = {
	"move_forward": [[INPUT_TYPE.KEY, KEY_W], [INPUT_TYPE.KEY, KEY_UP]],
	"move_backward": [[INPUT_TYPE.KEY, KEY_S], [INPUT_TYPE.KEY, KEY_DOWN]],
	"move_left": [[INPUT_TYPE.KEY, KEY_A], [INPUT_TYPE.KEY, KEY_LEFT]],
	"move_right": [[INPUT_TYPE.KEY, KEY_D], [INPUT_TYPE.KEY, KEY_RIGHT]],
	"move_jump": [null, [INPUT_TYPE.KEY, KEY_SPACE]],
	"context_action": [[INPUT_TYPE.MOUSE, BUTTON_LEFT], [INPUT_TYPE.KEY, KEY_E]]
}
var mapping_order = [
	"move_forward", "move_backward", "move_left", "move_right", "move_jump", "context_action"
]

var actions_mapping = default_mapping

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

func _ready() -> void:
	current_config = load_config()

func save_config(config: GameConfig) -> void:
	config.version = ProjectSettings.get("application/config/version")
	ResourceSaver.save("user://game-config.tres", config)

func load_config() -> GameConfig:
	var path : String = "user://game-config.tres"
	var config : GameConfig = GameConfig.new()
	if ResourceLoader.exists(path):
		config = ResourceLoader.load(path)
		config.update_config_version()
	return config

#	TranslationServer.set_locale(config.language)
#	OS.window_fullscreen = config.full_screen
#	set_screen_resolution(config.screen_resolution)
#	for bus in ["Master", "Music", "Sfx"]:
#		set_bus_volume(bus, config.volume[bus])
#	Data.MOUSE_SENSITIVITY = config.mouse_sensitivity
#	Data.INVERT_Y = config.mouse_y_inverted
#	if !config.mapping.empty():
#		Data.actions_mapping = config.mapping
#		update_actions_mapping()

func update_actions_mapping() -> void:
	for action in Data.actions_mapping:
		for input in InputMap.get_action_list(action):
			if input is InputEventKey or input is InputEventMouseButton:
				InputMap.action_erase_event(action, input)
		for input in Data.actions_mapping[action]:
			match input:
				[INPUT_TYPE.MOUSE, var button_index]:
					var new_input = InputEventMouseButton.new()
					new_input.button_index = button_index
					InputMap.action_add_event(action, new_input)
				[INPUT_TYPE.KEY, var scancode]:
					var new_input = InputEventKey.new()
					new_input.scancode = scancode
					InputMap.action_add_event(action, new_input)
				_: pass

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

func set_crossair_visibility(visible: bool) -> void:
	emit_signal("crosshair_visibility_changed", visible)

func set_player_fov(value: float) -> void:
	var new_fov = lerp(FOV_MIN, FOV_MAX, value)
	emit_signal("fov_changed", new_fov)

func set_gamma(value: float) -> void:
	var new_gamma = lerp(GAMMA_MIN, GAMMA_MAX, value)
	emit_signal("gamma_changed", new_gamma)

func set_vsync(use_vsync: bool) -> void:
	OS.vsync_enabled = use_vsync
