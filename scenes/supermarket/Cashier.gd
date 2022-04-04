class_name Cashier extends Spatial

signal player_checkout

export(bool) var with_cashier = true
onready var trigger : InteractTrigger = $InteractTrigger
onready var forbidden : MeshInstance = $Cashier/Nope
onready var employee = $Cashier/Employee
onready var block : StaticBody = $Cashier/BlockPath
var can_checkout : bool = false

func _ready() -> void:
	employee.visible = true

func reset() -> void:
	can_checkout = false
	block.collision_layer = 3
	employee.visible = true
	_update_cashier()

func desert() -> void:
	employee.visible = false
	block.collision_layer = 0
	forbidden.visible = false

func player_ready_to_checkout() -> void:
	can_checkout = true
	_update_cashier()

func _update_cashier() -> void:
	trigger.visible = can_checkout
	forbidden.visible = !can_checkout

func _on_InteractTrigger_interacted_with(_who) -> void:
	if can_checkout:
		emit_signal("player_checkout")
