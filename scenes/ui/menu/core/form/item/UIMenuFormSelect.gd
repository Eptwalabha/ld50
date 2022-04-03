class_name UIMenuFormSelect
extends UIMenuFormItem

onready var select : UIMenuSelect = $VBox/Input/Margin/Line/Select

export(Array, String) var values := ["true", "false"]
export(int) var current_selection := 0

func _ready() -> void:
	setup(values, current_selection)

func _on_Select_value_changed(value) -> void:
	emit_signal("value_changed", value)

func set_value(value) -> void:
	select.set_value(value)

func set_choices(choices: Array) -> void:
	values = choices
	select.set_choices(choices)

func input(event: InputEvent) -> void:
	select.input(event)

func get_value():
	return select.get_value()

func update_choices(choices: Array) -> void:
	values = choices
	if select != null:
		select.update_choices(choices)

func setup(choices: Array, current: int) -> void:
	values = choices
	current_selection = current
	select.setup(choices, current)
