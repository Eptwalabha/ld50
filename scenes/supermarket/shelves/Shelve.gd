class_name Shelve extends StaticBody

signal spawn_item_at(position)

var items : Array = []
export(String) var items_strs := ""
export(bool) var can_be_restock := true

onready var points = $Spawn

func _ready() -> void:
	items = items_strs.split(",")

func reset() -> void:
	for position in points.get_children():
		if position is ItemPosition:
			position.occupied = false

func available_positions(item_type: String) -> Array:
	if can_be_restock and items.has(item_type):
		var available_positions = []
		for position in points.get_children():
			if position is ItemPosition and !position.occupied:
				available_positions.append(position)
		return available_positions
	return []
