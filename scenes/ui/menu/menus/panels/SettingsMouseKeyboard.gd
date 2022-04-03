extends GameSubMenuPanel



func _on_Sensitivity_value_changed(value) -> void:
	Data.set_mouse_sensitivity(value)

func _on_InvertY_value_changed(value) -> void:
	Data.set_mouse_invert_y(value == "true")

func get_config() -> Dictionary:
	var config : Dictionary = {}
	config['mapping'] = Data.actions_mapping
	return config
