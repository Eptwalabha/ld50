class_name UIMenuFormSlider
extends UIMenuFormItem

onready var slider : UIMenuSlider = $VBox/Input/Margin/Line/Slider

export(float, 0, .1) var current_value := .5
export(bool) var allow_half_value := false

func _ready() -> void:
	slider.allow_half = allow_half_value
	set_value(current_value)

func set_value(value) -> void:
	current_value = value
	slider.set_value(value)

func input(event: InputEvent) -> void:
	slider.input(event)

func get_value() -> float:
	return slider.get_value()

func _on_Slider_value_changed(value) -> void:
	current_value = value
	emit_signal("value_changed", value)
