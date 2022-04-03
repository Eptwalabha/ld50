class_name UIMenuSlider
extends UIMenuBaseSelect

onready var bar_container : HBoxContainer = $Content/Bars

var _current_value : int = 50
export(bool) var allow_half := false

var img_null = preload("res://assets/images/ui/BarZero.svg")
var img_middle = preload("res://assets/images/ui/BarMiddle.svg")
var img_full = preload("res://assets/images/ui/BarFull.svg")

func _ready() -> void:
	update_bars()
	var i : float = 0.0
	for bar in bar_container.get_children():
		i += .1
		bar.connect("gui_input", self, "_on_gui_input", [i])

func update_bars() -> void:
	var i = 0
	var is_half : bool = allow_half and (_current_value % 10) == 5
	var current : int = int(floor(_current_value / 10.0))
	for item in bar_container.get_children():
		if i < current:
			item.modulate.a = 1.0
			item.set_texture(img_full)
		elif i == current and is_half:
			item.modulate.a = .75
			item.set_texture(img_middle)
		else:
			item.modulate.a = .5
			item.set_texture(img_null)
		i += 1

func set_value(new_value: float) -> void:
	_current_value = int(max(min(round(new_value * 100.0), 100.0), 0.0))
	update_bars()

func update_value(amount: float) -> void:
	set_value(amount)
	emit_signal("value_changed", get_value())

func get_value() -> float:
	return float(_current_value) / 100.0

func change_value(next: bool) -> void:
	var step : float = (.05 if allow_half else .1) * (1 if next else -1)
	var value : float = get_value()
	var new_value = max(min(value + step, 1.0), 0.0)
	if new_value != value:
		update_value(new_value)

func _on_gui_input(input: InputEvent, new_value: float) -> void:
	if input is InputEventMouseButton and input.is_pressed():
		update_value(new_value)
		$Next.play()
