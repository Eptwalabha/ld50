class_name GameSubMenuPanel
extends VBoxContainer

signal input_activated

export(String) var panel_name := "panel-name"

var inputs : Array = []
var current_input : UIMenuFormItem

func _ready() -> void:
	inputs = []
	for input in get_tree().get_nodes_in_group("input-line"):
		if ! self.is_a_parent_of(input) or ! input is UIMenuFormItem:
			continue
		inputs.append(input)
	var size : int = len(inputs)
	if size > 0:
		for i in range(size):
			var next = wrapi(i + 1, 0, size)
			var previous = wrapi(i - 1, 0, size)
			inputs[i].set_previous_neighbourg(inputs[previous])
			inputs[i].set_next_neighbourg(inputs[next])
			inputs[i].focus_neighbour_left = inputs[i].get_path()
			inputs[i].focus_neighbour_right = inputs[i].get_path()
			inputs[i].focus_neighbour_top = inputs[previous].get_path()
			inputs[i].focus_neighbour_bottom = inputs[next].get_path()
			inputs[i].connect("pressed", self, "_on_input_pressed", [inputs[i]])
		current_input = inputs[0]

func get_config() -> Dictionary:
	var config = {}
	for input in get_tree().get_nodes_in_group("input-line"):
		if ! is_a_parent_of(input) or ! input is UIMenuFormItem:
			config[input.input_name] = input.get_value()
	return config

func focus_new_input(new_input) -> void:
	if new_input == current_input or new_input == null or ! new_input is UIMenuFormItem:
		return
	current_input.exit()
	for input in inputs:
		input.focused = new_input == input
	current_input = new_input
	current_input.enter()
	current_input.grab_focus()

func enter() -> void:
	if len(inputs) > 0 and current_input == null:
		current_input = inputs[0]
	if current_input != null:
		current_input.focused = true
		current_input.enter()

func exit() -> void:
	if current_input != null:
		current_input.focused = true
		current_input.exit()

func input(event: InputEvent) -> void:
	if current_input == null:
		return
	if event.is_action_pressed("ui_down"):
		focus_new_input(current_input.next_focus)
	elif event.is_action_pressed("ui_up"):
		focus_new_input(current_input.previous_focus)
	else:
		current_input.input(event)

func _on_input_pressed(input) -> void:
	focus_new_input(input)
	emit_signal("input_activated")
