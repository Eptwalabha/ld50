class_name UIMenuFormSelectKeyboardMapping extends UIMenuFormSelect

onready var action_labels = $VBox/Helper/HBoxContainer/Actions

func _ready() -> void:
	_update_keyboard_choices()
	select.set_value(Data.KEYBOARD_MAPPING)

func _update_keyboard_choices() -> void:
	var choices = []
	for choice in Data.KEYBOARD_DISPOSITIONS:
		choices.append(choice)
	select.set_choices(choices)
	_update_labels()

func _update_labels() -> void:
	for label in action_labels.get_children():
		label.update_labels()

func _on_UIMenuFormSelectKeyboardMapping_value_changed(value) -> void:
	_update_labels()
