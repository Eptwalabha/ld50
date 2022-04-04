extends Spatial

onready var player : FPSPlayer = $FPSPlayer
onready var supermarket : Supermarket = $Supermarket
onready var intro : UIIntro = $UIIntro
onready var game_menu : GameMenu = $GameMenu
onready var grocery_list : GroceryList = $FPSPlayer/Head/Camera/Hand/GroceryList

var current_item : InteractTrigger

var player_can_checkout := false

enum STATE {
	INTRO,
	PLAYING,
	MENU,
	END_LEVEL
}

var game_state : int = STATE.INTRO

func _ready() -> void:
	_prepare_current_level()

func _prepare_current_level() -> void:
	var level = Data.LEVELS[Data.current_level]
	intro.start(Data.current_level)
	player.has_control = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var list = supermarket.generate(level)
	grocery_list.set_list(list)
	player_can_checkout = false

func _input(event: InputEvent) -> void:
	match game_state:
		STATE.PLAYING:
			_input_playing(event)
		STATE.MENU:
			pass

func _input_playing(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event.is_action_pressed("context_action"):
		if current_item != null:
			player.interact_with()
			var parent = current_item.get_parent()
			if parent is PickableItem and parent.is_grocery:
				grocery_list.item_picked(parent.type)
			current_item.interact_with(player)
			current_item = null
	if event.is_action_pressed("pause_game"):
		pause_game()

func replay_level() -> void:
#	Data.current_level -= 1
	next_level()

func next_level() -> void:
	player.has_control = false
	if player._current_interact != null:
		player._current_interact.queue_free()
		player._current_interact = null
	current_item = null
	supermarket.stop_level()
	game_state = STATE.END_LEVEL
	intro.next_level()

func pause_game() -> void:
	get_tree().paused = true
	game_state = STATE.MENU
	game_menu.open()

func resume_game() -> void:
	game_state = STATE.PLAYING
	game_menu.close()
	get_tree().set_input_as_handled()
	get_tree().paused = false

func _change_current_item(item: InteractTrigger) -> void:
	if current_item != null and current_item != item:
		current_item.exit()
	current_item = item
	current_item.hover()

func _remove_current_item(item: InteractTrigger) -> void:
	if current_item != null:
		if current_item != item:
			item.exit()
		current_item.exit()
	current_item = null

func _on_Supermarket_supermarket_generated() -> void:
	player.global_transform.origin = supermarket.random_starting_position()
	intro.level_ready()

func _on_FPSPlayer_interact_hovered(item) -> void:
	if item is InteractTrigger:
		_change_current_item(item)
	else:
		_remove_current_item(item)

func _on_FPSPlayer_interact_exited(item) -> void:
	_remove_current_item(item)

func _on_Supermarket_announce_dialog_ended() -> void:
	$Dialog.hide()

func _on_Supermarket_announce_dialog_started(key) -> void:
	$Dialog.display("pa-announcer", key)

func _on_UIIntro_faded_out() -> void:
	supermarket.start_level()
	grocery_list.start_level()
	game_state = STATE.PLAYING
	player.has_control = true

func _on_GameMenu_resume_game_requested() -> void:
	resume_game()

func _on_GameMenu_quit_game_requested() -> void:
	get_tree().quit()

func _on_GroceryList_all_items_picked_up() -> void:
	player_can_checkout = true

func _on_Supermarket_player_checkout() -> void:
	if player_can_checkout:
		next_level()

func _on_UIIntro_next_level_requested() -> void:
	Data.current_level += 1
	if Data.current_level >= len(Data.LEVELS):
		intro.end_of_game()
	else:
		_prepare_current_level()

func _on_Supermarket_level_timed_out() -> void:
	replay_level()
