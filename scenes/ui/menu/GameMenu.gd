class_name GameMenu
extends Control

signal resume_game_requested
signal quit_game_requested

onready var menu_selection = $MarginContainer/MainMenu/VBoxContainer/Menu/Scroll/Selection
onready var main_menu = $MarginContainer/MainMenu
onready var other_menus = $MarginContainer/SubMenus
onready var menu_credits : GameSubMenu = $MarginContainer/SubMenus/Credits
onready var menu_settings : GameSubMenu = $MarginContainer/SubMenus/Settings
onready var panel_change_sound : AudioStreamPlayer = $PanelChange
onready var settings : MenuSettings = $MarginContainer/SubMenus/Settings

export(String) var main_title : String = "pause"
export(bool) var show_btn_back : bool = false
export(bool) var show_btn_resume : bool = true
export(bool) var show_btn_quit : bool = true

enum MENU_STATE {
	MAIN_MENU,
	SUB_MENU
}

var current_state = MENU_STATE.MAIN_MENU
var current_menu : GameSubMenu = null

func _ready() -> void:
	menu_selection.find_node("Resume").visible = show_btn_resume
	menu_selection.find_node("QuitMenu").visible = show_btn_back
	menu_selection.find_node("Quit").visible = show_btn_quit
	$MarginContainer/MainMenu/Label.text = main_title
	for menu in other_menus.get_children():
		if menu is GameSubMenu:
			menu.connect("close_sub_menu_requested", self, "_on_sub_menu_closed", [menu])
	set_process_input(false)
	set_process(false)
	hide()

func open() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process_input(true)
	set_process(true)
	match current_state:
		MENU_STATE.MAIN_MENU:
			main_menu.show()
			menu_selection.enter()
			other_menus.hide()
		MENU_STATE.SUB_MENU:
			other_menus.show()
			current_menu.show()
			main_menu.hide()
	show()

func close() -> void:
	set_process_input(false)
	set_process(false)
	_play_panel_change(false)
	menu_selection.exit()
	save_config()
	hide()

func save_config() -> void:
	var config : GameConfig = get_config()
	Data.save_config(config)

func load_config() -> void:
	settings.load_config(Data.current_config)

func get_config() -> GameConfig:
	var config : GameConfig = GameConfig.new()
	config.data = settings.get_config()
	return config

func open_sub_menu(menu: GameSubMenu) -> void:
	if current_menu != null and menu != current_menu:
		current_menu.exit()
	other_menus.show()
	for sub_menu in other_menus.get_children():
		sub_menu.visible = sub_menu == menu
	current_menu = menu
	current_menu.enter()
	menu_selection.exit()
	current_state = MENU_STATE.SUB_MENU
	main_menu.hide()
	_play_panel_change(true)

func close_sub_menu() -> void:
	current_menu.exit()
	menu_selection.enter()
	other_menus.hide()
	main_menu.show()
	current_state = MENU_STATE.MAIN_MENU

func _input(event: InputEvent) -> void:
	if not visible:
		return
	match current_state:
		MENU_STATE.MAIN_MENU:
			if event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause_game"):
				emit_signal("resume_game_requested")
			else:
				menu_selection.input(event)
		MENU_STATE.SUB_MENU:
			if event.is_action_pressed("pause_game"):
				emit_signal("resume_game_requested")
			else:
				current_menu.input(event)

func _process(delta: float) -> void:
	if not visible:
		return
	match current_state:
		MENU_STATE.MAIN_MENU:
			pass
		MENU_STATE.SUB_MENU:
			current_menu.process(delta)

func _on_sub_menu_closed(_menu) -> void:
	_play_panel_change(false)
	close_sub_menu()

func _play_panel_change(entering : bool) -> void:
	panel_change_sound.pitch_scale = 1.3 if entering else 1.0
	panel_change_sound.play()

func _on_Selection_button_selected(button_name) -> void:
	match button_name:
		"quit_menu":
			menu_selection.deselect_all()
			emit_signal("resume_game_requested")
		"resume_game":
			menu_selection.deselect_all()
			emit_signal("resume_game_requested")
		"quit_game":
			emit_signal("quit_game_requested")
		"credits_panel":
			open_sub_menu(menu_credits)
		"settings_panel":
			open_sub_menu(menu_settings)
