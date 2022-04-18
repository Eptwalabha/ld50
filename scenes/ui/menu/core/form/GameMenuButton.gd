class_name GameMenuButton
extends Control

signal pressed(name)

onready var tween : Tween = $Tween
onready var sound : AudioStreamPlayer2D = $Sound
onready var label : Label = $Container/Button/Label
onready var overlay : ColorRect = $Overlay

export(bool) var selected := false
export(bool) var highlight := false
export(String) var button_name := "button" setget set_name
export(bool) var align_right := false

var focused : bool = false
var next_focus : GameMenuButton
var previous_focus : GameMenuButton

func _ready() -> void:
	label.text = button_name
	if align_right:
		label.align = Label.ALIGN_RIGHT

func set_highlight(is_highlight: bool) -> void:
	highlight = is_highlight
	_update_state(selected, focused)

func set_focus(is_focused: bool) -> void:
	_update_state(selected, is_focused)
	if is_focused:
		sound.play()

func set_selected(is_selected: bool) -> void:
	_update_state(is_selected, focused)

func _update_state(is_selected: bool, is_focused: bool) -> void:
	if is_selected != selected or is_focused != focused:
		selected = is_selected
		focused = is_focused
		var margin_property = "margin_right" if align_right else "margin_left"
		var margin_value = -20 if align_right else 20
		if selected or focused:
			tween.interpolate_property(label, margin_property, label[margin_property], margin_value, .2)
		else:
			tween.interpolate_property(label, margin_property, label[margin_property], 0, .2)
		if selected:
			tween.interpolate_property(label, "modulate:a", label.modulate.a, 1.0, .2)
		else:
			tween.interpolate_property(label, "modulate:a", label.modulate.a, .5, .2)
		tween.start()
	overlay.visible = selected and highlight

func _on_Button_mouse_entered() -> void:
	emit_signal("mouse_entered")
	_update_state(selected, true)
	sound.play()

func _on_Button_mouse_exited() -> void:
	emit_signal("mouse_exited")
	_update_state(selected, false)
	tween.start()

func _on_Button_pressed() -> void:
	emit_signal("pressed", button_name)

func set_name(new_name: String) -> void:
	button_name = new_name
	$Container/Button/Label.text = new_name

func _on_Overlay_item_rect_changed() -> void:
	if overlay != null:
		overlay.material.set_shader_param("size", rect_size)
