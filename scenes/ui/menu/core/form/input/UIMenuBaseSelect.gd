class_name UIMenuBaseSelect
extends HBoxContainer

signal value_changed(value)

onready var left_btn = $Left
onready var right_btn = $Right
onready var animation : AnimationPlayer = $AnimationPlayer

func input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		_change_value(false)
	elif event.is_action_pressed("ui_right"):
		_change_value(true)

func _change_value(next: bool) -> void:
	animation.play("right" if next else "left")
	change_value(next)

func set_value(_value) -> void:
	pass

func change_value(_next: bool) -> void:
	pass

func set_bus(bus_name) -> void:
	$Previous.bus = bus_name
	$Next.bus = bus_name

func _on_Left_pressed() -> void:
	_change_value(false)


func _on_Right_pressed() -> void:
	_change_value(true)
