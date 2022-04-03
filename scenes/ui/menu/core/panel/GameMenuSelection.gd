class_name GameMenuSelection
extends VBoxContainer

signal button_selected(button_name)

const MyButton = preload("res://scenes/ui/menu/core/form/GameMenuButton.tscn")

export(bool) var highlight := true

var current_button : GameMenuButton
var buttons : Array = []

func _ready() -> void:
	for button in get_children():
		if button is GameMenuButton:
			button.connect("pressed", self, "_on_Button_pressed", [button])
	_update_buttons_focus()
	_set_buttons_highlight(highlight)

func input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		focus_previous_button()
	elif event.is_action_pressed("ui_down"):
		focus_next_button()
	elif event.is_action_pressed("ui_accept"):
		emit_signal("button_selected", current_button.button_name)

func focus_next_button() -> void:
	if len(buttons) > 0:
		if current_button != null:
			_focus_button(current_button.next_focus)
		else:
			_focus_button(buttons[0])

func focus_previous_button() -> void:
	if len(buttons) > 0:
		if current_button != null:
			_focus_button(current_button.previous_focus)
		else:
			_focus_button(buttons[0])

func deselect_all() -> void:
	current_button = null
	for button in buttons:
		button.set_selected(false)
		button.set_focus(false)

func enter() -> void:
	if len(buttons) > 0 and current_button == null:
		current_button = buttons[0]
	if current_button != null:
		current_button.set_selected(true)
	_set_buttons_highlight(highlight)

func _focus_button(new_button: GameMenuButton) -> void:
	if new_button == null or new_button == current_button or ! new_button is GameMenuButton:
		return
	current_button = new_button
	for button in buttons:
		if button is GameMenuButton:
			button.set_focus(button == current_button)
			button.set_selected(button == current_button)

func exit() -> void:
	_set_buttons_highlight(false)
	
func _set_buttons_highlight(is_highlighted: bool) -> void:
	for button in buttons:
		if button is GameMenuButton:
			button.set_highlight(is_highlighted)

func add_button(button_name) -> void:
	var button : GameMenuButton = MyButton.instance()
	add_child(button)
	button.button_name = button_name
	button.highlight = highlight
	button.connect("pressed", self, "_on_Button_pressed", [button])
	_update_buttons_focus()

func _update_buttons_focus() -> void:
	buttons = []
	for button in get_children():
		if ! button is GameMenuButton:
			continue
		buttons.append(button)
	var size = len(buttons)
	for i in range(size):
		var next = wrapi(i + 1, 0, size)
		var previous = wrapi(i - 1, 0, size)
		buttons[i].next_focus = buttons[next]
		buttons[i].previous_focus = buttons[previous]

func _on_Button_pressed(_button_name: String, button: GameMenuButton) -> void:
	for b in buttons:
		b.set_selected(b == button)
	current_button = button
	emit_signal("button_selected", button.button_name)
