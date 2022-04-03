class_name GameSubMenuWithOptions
extends GameSubMenu

onready var menu : GameMenuSelection = $VBoxContainer/Menu/Scroll/GameMenuSelection
onready var panels : MarginContainer = $VBoxContainer/Panels/Margin/Scroll/Panels
onready var panel_change_sound : AudioStreamPlayer = $PanelChange

enum SUBMENU_STATE {
	PANEL_SELECTION,
	PANEL
}

var state = SUBMENU_STATE.PANEL_SELECTION
var current_panel : GameSubMenuPanel

const GameMemuButton = preload("res://scenes/ui/menu/core/form/GameMenuButton.tscn")

func _ready() -> void:
	_build_side_menu()
	menu.enter()

func _build_side_menu() -> void:
	for panel in panels.get_children():
		if panel is GameSubMenuPanel:
			menu.add_button(panel.panel_name)
			panel.connect("input_activated", self, "_on_Action_on_panel", [panel])

func input(event: InputEvent) -> void:
	match state:
		SUBMENU_STATE.PANEL_SELECTION:
			if event.is_action_pressed("ui_cancel"):
				emit_signal("close_sub_menu_requested")
			else:
				menu.input(event)
		SUBMENU_STATE.PANEL:
			if current_panel == null:
				state = SUBMENU_STATE.PANEL_SELECTION
			else:
				if event.is_action_pressed("ui_cancel"):
					_play_panel_change(false)
					focus_main_menu()
					current_panel.exit()
				else:
					current_panel.input(event)

func focus_main_menu() -> void:
	if state == SUBMENU_STATE.PANEL:
		menu.enter()
		if current_panel != null:
			current_panel.exit()
	state = SUBMENU_STATE.PANEL_SELECTION

func focus_current_panel(play_sound : bool) -> void:
	if state == SUBMENU_STATE.PANEL_SELECTION:
		menu.exit()
	if current_panel != null:
		state = SUBMENU_STATE.PANEL
		current_panel.enter()
		if play_sound:
			_play_panel_change(true)

func change_current_panel(new_panel: GameSubMenuPanel) -> void:
	if current_panel == new_panel:
		return
	for panel in panels.get_children():
		panel.visible = new_panel == panel
	if current_panel != null:
		current_panel.exit()
	current_panel = new_panel
	current_panel.enter()

func _play_panel_change(entering : bool) -> void:
	panel_change_sound.pitch_scale = 1.3 if entering else 1.0
	panel_change_sound.play()

func _on_GameMenuSelection_button_selected(button_name) -> void:
	for panel in panels.get_children():
		if ! panel is GameSubMenuPanel:
			continue
		if panel.panel_name == button_name:
			change_current_panel(panel)
			break
	focus_current_panel(true)

func _on_Action_on_panel(panel: GameSubMenuPanel) -> void:
	if state == SUBMENU_STATE.PANEL_SELECTION:
		change_current_panel(panel)
		focus_current_panel(false)
