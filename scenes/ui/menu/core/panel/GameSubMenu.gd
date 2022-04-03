class_name GameSubMenu
extends VBoxContainer

signal close_sub_menu_requested

onready var sub_menu_title : Label = $Title/Control/SubMenuTitle
onready var tween : Tween = $Tween

const GameMenuButton = preload("res://scenes/ui/menu/core/form/GameMenuButton.tscn")

export(String) var sub_menu_name := "sub-menu" setget _set_sub_menu_name

func process(_delta: float) -> void:
	pass

func _ready() -> void:
	sub_menu_title.text = sub_menu_name

func get_config() -> Dictionary:
	return {}

func enter() -> void:
	show()
	tween.interpolate_property(sub_menu_title, "margin_left", 20, 0, .3)
	tween.start()

func exit() -> void:
	pass

func _set_sub_menu_name(new_name: String) -> void:
	sub_menu_name = new_name
	$Title/Control/SubMenuTitle.text = tr(sub_menu_name)

func input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		emit_signal("close_sub_menu_requested")


func _on_Back_pressed() -> void:
	emit_signal("close_sub_menu_requested")
