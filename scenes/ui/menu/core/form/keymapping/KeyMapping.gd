class_name KeyMapping
extends HBoxContainer

signal change_requested(map, map_id)

var action : String = ""
onready var action_label := $Action
onready var key1_btn := $Key1
onready var key2_btn := $Key2

func set_action(the_action: String) -> void:
	action = the_action
	action_label.text = tr("key_%s" % the_action)

func set_key(index: int, text: String) -> void:
	if index == 0:
		key1_btn.text = text
	else:
		key2_btn.text = text

func _on_Key1_pressed() -> void:
	emit_signal("change_requested", action, 0)

func _on_Key2_pressed() -> void:
	emit_signal("change_requested", action, 1)
