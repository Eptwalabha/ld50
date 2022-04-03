class_name UIMenuFormItem
extends MarginContainer

signal value_changed(value)
signal pressed

onready var overlay : ColorRect = $VBox/Input/Overlay
onready var label : Label = $VBox/Input/Margin/Line/Label

var focused : bool = false
var next_focus : UIMenuFormItem
var previous_focus : UIMenuFormItem

export(String) var input_name : String = "input"

func _ready() -> void:
	label.text = "label_%s" % input_name
	overlay.material.set_shader_param("size", rect_size)
	connect("item_rect_changed", self, "_on_UIMenuFormItem_item_rect_changed")

func set_input_name(new_input_name) -> void:
	input_name = new_input_name
	label.text = "input_%s" % input_name

func set_previous_neighbourg(the_previous: Control) -> void:
	previous_focus = the_previous

func set_next_neighbourg(the_next: Control) -> void:
	next_focus = the_next

func enter() -> void:
	overlay.show()
	$Enter.play()

func exit() -> void:
	overlay.hide()

func set_value(_new_value) -> void:
	pass

func get_value():
	return ""

func input(_event: InputEvent) -> void:
	pass

func _on_UIMenuFormItem_item_rect_changed() -> void:
	var line_container = $VBox/Input/Margin
	overlay.material.set_shader_param("size", line_container.rect_size)

func _on_UIMenuFormItem_mouse_entered() -> void:
	overlay.show()

func _on_UIMenuFormItem_mouse_exited() -> void:
	overlay.hide()

func _on_UIMenuFormItem_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		emit_signal("pressed")
