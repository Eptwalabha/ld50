class_name GroceryItemLine extends HBoxContainer

signal item_type_completed(type)

var type := "null"
var quantity : int = 0
var goal : int = 1

func setup(item_type: String, item_quantity: int) -> void:
	$Strike.visible = false
	type = item_type
	$Item/Control/Texture.frame = Data.ITEMS.find(item_type)
	$ItemName.text = item_type
	goal = item_quantity
	quantity = 0
	update_quantity()
	update_strike()

func update_quantity() -> void:
	$Quantity.text = "%d / %d" % [quantity, goal]

func item_picked(item_type: String) -> void:
	if item_type == type:
		quantity += 1
		if quantity == goal:
			emit_signal("item_type_completed", type)
	update_quantity()
	update_strike()

func update_strike() -> void:
	$Strike.visible = (quantity >= goal)

func is_complete() -> bool:
	return quantity >= goal
