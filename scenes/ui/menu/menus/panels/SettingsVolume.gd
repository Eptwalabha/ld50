class_name SettingsVolume
extends GameSubMenuPanel


func _on_Master_value_changed(value) -> void:
	Data.set_bus_volume("Master", value)

func _on_Music_value_changed(value) -> void:
	Data.set_bus_volume("Music", value)

func _on_Sfx_value_changed(value) -> void:
	Data.set_bus_volume("Sfx", value)

func get_config() -> Dictionary:
	var config : Dictionary = {
		'volume': {}
	}
	for input in get_tree().get_nodes_in_group("input-line"):
		if is_a_parent_of(input) and input is UIMenuFormItem:
			config['volume'][input.input_name] = input.get_value()
	return config
