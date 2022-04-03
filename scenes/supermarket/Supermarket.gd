class_name Supermarket extends Spatial

signal supermarket_generated
signal announce_dialog_started(key)
signal announce_dialog_ended

var Item = preload("res://scenes/supermarket/item/PickableItem.tscn")

func _ready() -> void:
	
	pass

func generate() -> void:
	_generate_supermarket()
	_generate_goods()

func _generate_supermarket() -> void:
	for shelve in $Shelves.get_children():
		if shelve is Shelve:
			shelve.connect("spawn_item_at", self, "_on_spawn_item")

func _generate_goods() -> void:
	for shelve in $Shelves.get_children():
		if shelve is Shelve:
			shelve.generate_goods()
	emit_signal("supermarket_generated")

func _on_spawn_item(the_position: Vector3) -> void:
	var good = Item.instance()
	$Goods.add_child(good)
	good.global_transform.origin = the_position


func start_level() -> void:
#	if not Data.DEBUG:
	$Clock.reset_clock(false)
	$AnimationPlayer.play("pa-closing")

func new_promotion() -> void:
	$AnimationPlayer.play("pa-new_promotion")

func announce_dialog(key: String) -> void:
	emit_signal("announce_dialog_started", key)

func announce_dialog_end() -> void:
	emit_signal("announce_dialog_ended")
