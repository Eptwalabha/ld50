class_name Cashier extends Spatial

signal player_checkout

export(bool) var with_cashier = true

func _ready() -> void:
	$Cashier/Employee.visible = with_cashier


func _on_InteractTrigger_interacted_with(_who) -> void:
	emit_signal("player_checkout")
