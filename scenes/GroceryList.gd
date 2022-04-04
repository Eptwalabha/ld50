class_name GroceryList extends Spatial

signal all_items_picked_up

onready var ui = $Viewport/UIGroceryList
onready var anim : AnimationPlayer = $AnimationPlayer

var all_picked_up : bool = false

func set_list(list) -> void:
	ui.set_list(list)
	anim.play("RESET")

func start_level() -> void:
	all_picked_up = false
	anim.play("start")

func item_picked(item_type: String) -> void:
	ui.item_picked(item_type)

func _on_UIGroceryList_all_items_picked_up() -> void:
	if !all_picked_up:
		all_picked_up = true
		emit_signal("all_items_picked_up")
		anim.play("all_done")
