class_name Supermarket extends Spatial

signal supermarket_generated
signal player_checkout
signal level_timed_out

signal announce_dialog_started(key)
signal announce_dialog_ended

onready var shelves = $Navigation/NavigationMeshInstance/Shelves
onready var goods = $Goods
onready var promotion_timer: Timer = $Promotion
onready var level_timeout: Timer = $End
onready var start_timer : Timer = $StartLevel
onready var anim : AnimationPlayer = $AnimationPlayer
onready var player_spawn = $Navigation/NavigationMeshInstance/PlayerSpawn
onready var ad : AdScreen = $Viewport/PromoAd
onready var clocks = $Clocks
onready var cashiers = $Navigation/NavigationMeshInstance/Cashiers

var current_promotion: String = ""

const items = {
	"can_of_soup": preload("res://scenes/supermarket/item/grocery/CanOfSoup.tscn"),
	"box_of_cereal": preload("res://scenes/supermarket/item/grocery/BoxOfCereal.tscn"),
	"meat": preload("res://scenes/supermarket/item/grocery/Meat.tscn"),
	"soda_01": preload("res://scenes/supermarket/item/grocery/Soda01.tscn"),
	"soda_02": preload("res://scenes/supermarket/item/grocery/Soda02.tscn"),
	"toilet_paper": preload("res://scenes/supermarket/item/grocery/ToiletPaper.tscn"),
	"coffee": preload("res://scenes/supermarket/item/grocery/Coffee.tscn"),
	"snacks_01": preload("res://scenes/supermarket/item/grocery/Snacks01.tscn"),
	"snacks_02": preload("res://scenes/supermarket/item/grocery/Snacks02.tscn"),
	"instant_noodle": preload("res://scenes/supermarket/item/grocery/InstantNoodle.tscn"),
	"fruits": preload("res://scenes/supermarket/item/grocery/Fruits.tscn"),
	"vegetables": preload("res://scenes/supermarket/item/grocery/Vegetables.tscn"),
	"sugar": preload("res://scenes/supermarket/item/grocery/Sugar.tscn")
}

var promotion_delay : float = 15.0
var level_delay : float = 60.0

func _ready() -> void:
	ad.turn(false)

func generate(level: Dictionary) -> Array:
	level_delay = level.time
	promotion_delay = level.promo_delay
	_reset_supermarket()
	_generate_supermarket()
	var new_list = _generate_goods(level.list)
	_generate_goods(_random_items_list(level))
	emit_signal("supermarket_generated")
	_reset_cashiers()
	_reset_clocks()
	_play_music(level.music)
	return new_list

func _reset_cashiers() -> void:
	for cashier in cashiers.get_children():
		if cashier is Cashier:
			cashier.reset()
			if level_delay <= 0:
				cashier.desert()

func player_ready_to_checkout() -> void:
	for cashier in cashiers.get_children():
		if cashier is Cashier:
			cashier.player_ready_to_checkout()

func _reset_clocks() -> void:
	for clock in clocks.get_children():
		if clock is Clock:
			clock.reset(false)

func _start_clocks(time: float) -> void:
	for clock in clocks.get_children():
		if clock is Clock:
			clock.start(time)

func random_starting_position() -> Vector3:
	return player_spawn.get_child(randi() % player_spawn.get_child_count()).global_transform.origin

func _random_items_list(level: Dictionary) -> Array:
	var amount : int = int(max(5, 40 - Data.current_level * 10))
	return [
		["can_of_soup", randi() % amount],
		["box_of_cereal", randi() % amount],
		["meat", randi() % amount],
		["soda_01", randi() % amount],
		["soda_02", randi() % amount],
		["toilet_paper", randi() % amount],
		["coffee", randi() % amount],
		["snacks_01", randi() % amount],
		["snacks_02", randi() % amount],
		["instant_noodle", randi() % amount],
		["fruits", randi() % amount],
		["vegetables", randi() % amount],
		["sugar", randi() % amount]
	]

func _reset_supermarket() -> void:
	for shelve in shelves.get_children():
		if shelve is Shelve:
			shelve.reset()

	for good in goods.get_children():
		goods.remove_child(good)
		good.queue_free()

func _generate_supermarket() -> void:
	pass

func _generate_goods(grocery_list: Array) -> Array:
	var placed_items : Array = []
	for item in grocery_list:
		var item_type = item[0]
		var item_quantity = item[1]
		var available_positions = _get_available_positions(item_type)
		var nbr_available = len(available_positions)
		if item_quantity > nbr_available:
			item_quantity = nbr_available
		if item_quantity > 0:
			var TheItem = items[item_type]
			for i in range(item_quantity):
				var p_i = randi() % len(available_positions)
				var random_position = available_positions[p_i]
				random_position.occupied = true
				available_positions.remove(p_i)
				var node = TheItem.instance()
				goods.add_child(node)
				node.global_transform.origin = random_position.global_transform.origin
			placed_items.append([item_type, item_quantity])
	return placed_items

func _get_available_positions(item_type: String) -> Array:
	var available_positions : Array = []
	for shelve in shelves.get_children():
		if shelve is Shelve:
			available_positions.append_array(shelve.available_positions(item_type))
	return available_positions

func start_level() -> void:
	if level_delay > 0:
		ad.turn(false)
		_start_clocks(level_delay)
		anim.play("pa-closing")
		start_timer.start()
		level_timeout.start(level_delay)

func _play_music(playing : bool = true) -> void:
	for audio in $Music.get_children():
		if audio is AudioStreamPlayer3D:
			audio.playing = playing

func give_time_bonus() -> void:
	if level_delay <= 0:
		return
	level_timeout.start(min(level_delay, level_timeout.time_left + Data.TIME_BONUS))
	for clock in clocks.get_children():
		if clock is Clock:
			clock.acc = max(0.0, clock.acc - Data.TIME_BONUS)

func new_promotion() -> void:
	if !ad.on:
		ad.turn(true)
	current_promotion = Data.ITEMS[randi() % len(Data.ITEMS)]
	ad.set_current_promotion(current_promotion, promotion_delay)
	anim.play("pa-new_promotion")

func announce_dialog(key: String) -> void:
	emit_signal("announce_dialog_started", key)

func announce_dialog_end() -> void:
	emit_signal("announce_dialog_ended")

func _on_Cashier_player_checkout() -> void:
	emit_signal("player_checkout")

func _on_End_timeout() -> void:
	emit_signal("level_timed_out")

func _on_Promotion_timeout() -> void:
	new_promotion()

func stop_level() -> void:
	promotion_timer.stop()
	level_timeout.stop()
	_reset_clocks()

func _on_GroceryList_all_items_picked_up() -> void:
	player_ready_to_checkout()

func _on_StartLevel_timeout() -> void:
	new_promotion()
	promotion_timer.start(promotion_delay)
