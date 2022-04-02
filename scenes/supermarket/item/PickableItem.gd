class_name PickableItem extends Spatial

onready var trigger : InteractTrigger = $InteractTrigger



func _on_InteractTrigger_interacted_with(who) -> void:
	print(who)
