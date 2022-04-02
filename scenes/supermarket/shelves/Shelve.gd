class_name Shelve extends StaticBody

signal spawn_item_at(position)

export(bool) var can_be_restock := true

func generate_goods() -> void:
	if can_be_restock:
		for spawn_position in $Spawn.get_children():
			if randf() > Data.scarcity:
				emit_signal("spawn_item_at", spawn_position.global_transform.origin)

	for spawn_position in $Spawn.get_children():
		spawn_position.queue_free()
