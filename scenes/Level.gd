extends Spatial

onready var player : FPSPlayer = $FPSPlayer
onready var supermarket : Supermarket = $Supermarket
onready var intro : UIIntro = $UIIntro
onready var promotion_timer : Timer = $Promotion
onready var game_menu : GameMenu = $GameMenu

var current_item : InteractTrigger

var player_credits : int = 0
var player_daily_credits : int = 100
var player_objective : int = 0

enum STATE {
	INTRO,
	PLAYING,
	MENU
}

var game_state : int = STATE.INTRO

func _ready() -> void:
	intro.start("title", "test")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player.has_control = false
	supermarket.generate()

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
			current_item = null
	if event.is_action_pressed("pause_game"):
		pause_game()

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
	promotion_timer.start()
	game_state = STATE.PLAYING
	player.has_control = true

func _on_Promotion_timeout() -> void:
	generate_new_promotion()

func generate_new_promotion() -> void:
#	var item_type = random_item()
	supermarket.new_promotion()

func _on_GameMenu_resume_game_requested() -> void:
	resume_game()

func _on_GameMenu_quit_game_requested() -> void:
	get_tree().quit()
