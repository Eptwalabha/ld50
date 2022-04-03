class_name KeyRemapper
extends VBoxContainer

signal input_requested(mapper, action, index)

const KeyMapping = preload("res://scenes/ui/menu/core/form/keymapping/KeyMapping.tscn")

var lines = {}

func _ready() -> void:
	for action in Data.mapping_order:
		var map : KeyMapping = KeyMapping.instance()
		add_child(map)
		lines[action] = map
		var mapping = Data.actions_mapping[action]
		map.set_action(action)
		map.set_key(0, input_to_text(mapping[0]))
		map.set_key(1, input_to_text(mapping[1]))
		map.connect("change_requested", self, "_on_Mapping_change_requested")

func input_to_text(input) -> String:
	match input:
		[Data.INPUT_TYPE.MOUSE, var mouse_index]: return "MOUSE_%s" % mouse_index
		[Data.INPUT_TYPE.KEY, var scancode]: return OS.get_scancode_string(scancode).to_upper()
		_: return "-"

func get_input(action, index):
	return Data.actions_mapping[action][index]

func set_input_neighbours(previous, next) -> void:
	var size = len(Data.mapping_order)
	for i in range(size):
		var action = Data.mapping_order[i]
		var map : KeyMapping = lines[action]
		map.key1_btn.focus_neighbour_left = map.key2_btn.get_path()
		map.key1_btn.focus_neighbour_right = map.key2_btn.get_path()
		map.key1_btn.focus_neighbour_left = map.key2_btn.get_path()
		map.key1_btn.focus_neighbour_right = map.key2_btn.get_path()
		if i == 0:
			map.key1_btn.focus_neighbour_top = previous.get_path()
			map.key2_btn.focus_neighbour_top = previous.get_path()
			previous.focus_neighbour_bottom = map.key1_btn.get_path()
		else:
			var previous_map = lines[Data.mapping_order[i - 1]]
			map.key1_btn.focus_neighbour_top = previous_map.key1_btn.get_path()
			map.key2_btn.focus_neighbour_top = previous_map.key2_btn.get_path()
		if i == size - 1:
			map.key1_btn.focus_neighbour_bottom = next.get_path()
			map.key2_btn.focus_neighbour_bottom = next.get_path()
			next.focus_neighbour_top = map.key1_btn.get_path()
		else:
			var next_map = lines[Data.mapping_order[i + 1]]
			map.key1_btn.focus_neighbour_bottom = next_map.key1_btn.get_path()
			map.key2_btn.focus_neighbour_bottom = next_map.key2_btn.get_path()

func _on_Mapping_change_requested(action, index) -> void:
	emit_signal("input_requested", self, action, index)

func update_input(action: String, index: int, new_input) -> void:
	for a in Data.actions_mapping:
		for i in range(2):
			var input = Data.actions_mapping[a][i]
			if a == action and i == index:
				lines[a].set_key(i, input_to_text(new_input))
				Data.actions_mapping[a][i] = new_input
			elif new_input != null and input != null and input[0] == new_input[0] and input[1] == new_input[1]:
				lines[a].set_key(i, input_to_text(null))
				Data.actions_mapping[a][i] = null
	Data.update_actions_mapping()
