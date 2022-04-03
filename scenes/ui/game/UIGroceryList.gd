class_name UIGroceryList extends Control

signal all_items_picked_up

const ListeLine = preload("res://scenes/ui/game/GroceryItemLine.tscn")

onready var container = $VBoxContainer/VBoxContainer

func set_list(list) -> void:
	for item in container.get_children():
		item.queue_free()

	for item in list:
		var item_type = item[0]
		var quantity = item[1]
		var line = ListeLine.instance()
		container.add_child(line)
		line.setup(item_type, quantity)
		line.connect("item_type_completed", self, "_on_item_type_complete")

func item_picked(item_type: String) -> void:
	var complete = true
	for line in container.get_children():
		if line is GroceryItemLine:
			line.item_picked(item_type)
			if !line.is_complete():
				complete = false
	if complete:
		emit_signal("all_items_picked_up")

func _on_item_type_complete(_item_type: String) -> void:
	pass
