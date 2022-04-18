class_name MainMenu extends Node

onready var main_menu : MarginContainer = $CanvasLayer/MainMenu
onready var game_menu : GameMenu = $CanvasLayer/GameMenu
onready var continue_btn : GameMenuButton = $CanvasLayer/MainMenu/VBoxContainer/Buttons/Continue
onready var transition : ScreenTransition = $CanvasLayer/ScreenTransition

func _ready() -> void:
	get_tree().paused = false
	continue_btn.visible = Data.current_level > 0
	transition.fade_in()

func _on_Quit_pressed(_btn_name: String) -> void:
	get_tree().quit(0)

func _on_Settings_pressed(_btn_name: String) -> void:
	main_menu.hide()
	game_menu.open()

func _on_GameMenu_resume_game_requested() -> void:
	main_menu.show()
	game_menu.close()

func _on_Start_pressed(_btn_name: String) -> void:
	Data.current_level = 0
	transition.fade_out()

func _on_Continue_pressed(_btn_name: String) -> void:
	transition.fade_out()

func _on_ScreenTransition_fade_out_ended() -> void:
	get_tree().change_scene("res://scenes/Level.tscn")
