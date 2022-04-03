class_name KeyMappingDialog
extends Control

signal popup_closed

var _current_action : String
var _current_index : int = 0
var _current_mapper : KeyRemapper

onready var title : Label = $Panel/VBoxContainer/Panel/Title
onready var key : Label = $Panel/VBoxContainer/Key

func _ready() -> void:
	close()

func open(mapper: KeyRemapper, action: String, index: int) -> void:
	_current_mapper = mapper
	_current_action = action
	_current_index = index
	var action_name = "key_%s" % action
	title.text = tr("waiting_for_input") % tr(action_name)
	match mapper.get_input(action, index):
		[Data.INPUT_TYPE.KEY, var scancode]:
			key.text = OS.get_scancode_string(scancode).to_upper()
		[Data.INPUT_TYPE.MOUSE, var mouse_index]:
			key.text = "MOUSE_%s" % mouse_index
		_:
			key.text = tr("no_scancode_yet")
	show()
	set_process_input(true)

func close() -> void:
	set_process_input(false)
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action("pause_game"):
		_request_close()
	else:
		if event is InputEventMouseButton and event.is_pressed():
			var new_input = [Data.INPUT_TYPE.MOUSE, event.button_index]
			_current_mapper.update_input(_current_action, _current_index, new_input)
			_request_close()
		elif event is InputEventKey and event.is_pressed():
			var new_input = [Data.INPUT_TYPE.KEY, event.scancode]
			_current_mapper.update_input(_current_action, _current_index, new_input)
			_request_close()

func _request_close() -> void:
	get_tree().set_input_as_handled()
	set_process_input(false)
	emit_signal("popup_closed")

