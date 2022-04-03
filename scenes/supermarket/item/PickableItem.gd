class_name PickableItem extends Spatial

onready var trigger : InteractTrigger = $InteractTrigger

export(String) var type := "null"

func _on_InteractTrigger_interacted_with(_who) -> void:
	queue_free()
