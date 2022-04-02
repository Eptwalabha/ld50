class_name GameConfig
extends Resource

export var version : String = ProjectSettings.get("application/config/version")

export var data : Dictionary = {}

export var language : String = "en"
export var full_screen : bool = ProjectSettings.get("display/window/size/fullscreen")
export var screen_resolution : Vector2 = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))
export var volume : Dictionary = {}

export var mouse_sensitivity : float = 0.5
export var mouse_y_inverted : bool = false

export var mapping : Dictionary = {}

func update_config_version() -> void:
	match version:
		"old_version":
			# try to update data to latest version
			# call this function recursively if needed
			version = "latest"
		_ :
			return

func get(key: String):
	var the_data : Dictionary = data
	for part in key.split("/", false):
		if ! (the_data is Dictionary and the_data.has(part)):
			return null
		the_data = the_data[part]
	return the_data
