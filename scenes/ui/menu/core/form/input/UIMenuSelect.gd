class_name UIMenuSelect
extends UIMenuBaseSelect

onready var label = $Content/Label

export(Array, String) var choices := ["true", "false"]
export(int) var current_choice := 0

func _ready() -> void:
	if len(choices) > 0:
		current_choice = wrapi(current_choice, 0, len(choices))
		label.text = choices[current_choice]
	else:
		queue_free()

func set_choice(value) -> void:
	current_choice = int(clamp(value, 0.0, len(choices)))
	label.text = choices[current_choice]

func set_choices(new_choices) -> void:
	if len(new_choices) == 0:
		return
	choices = new_choices
	set_choice(current_choice)

func update_choice(value) -> void:
	set_choice(value)
	emit_signal("value_changed", choices[current_choice])

func update_choices(new_choices: Array) -> void:
	set_choices(new_choices)
	emit_signal("value_changed", choices[current_choice])

func setup(new_choices: Array, new_selected_choice: int) -> void:
	set_choices(new_choices)
	set_choice(new_selected_choice)

func get_value():
	return choices[current_choice]

func change_value(next: bool) -> void:
	var next_choice = wrapi(current_choice + (1 if next else -1), 0, len(choices))
	if current_choice != next_choice:
		update_choice(next_choice)

func _on_Label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		change_value(true)
