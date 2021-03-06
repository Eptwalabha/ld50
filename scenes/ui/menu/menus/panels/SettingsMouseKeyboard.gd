extends GameSubMenuPanel

func _ready() -> void:
	$Mouse/Mouse/Sensitivity.set_value(Data.get_mouse_sensitivity_value())
	$Mouse/Mouse/InvertY.set_value(Data.get_mouse_invert_y_value())

func _on_Sensitivity_value_changed(value) -> void:
	Data.set_mouse_sensitivity(value)

func _on_InvertY_value_changed(value) -> void:
	Data.set_mouse_invert_y(value == "true")

func get_config() -> Dictionary:
	var config : Dictionary = {}
	config['mapping'] = Data.actions_mapping
	return config

func _on_UIMenuFormSelectKeyboardMapping_value_changed(value) -> void:
	Data.set_keyboard_mapping(value)
