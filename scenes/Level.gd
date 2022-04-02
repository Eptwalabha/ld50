extends Spatial

onready var player : FPSPlayer = $FPSPlayer
onready var supermarket : Supermarket = $Supermarket
onready var intro : UIIntro = $UIIntro

var current_item : InteractTrigger

func _ready() -> void:
	intro.start("title", "test")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	player.has_control = false
	supermarket.generate()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif event.is_action_pressed("context_action"):
		if current_item != null:
			player.interact_with()
			current_item = null

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
	player.has_control = true
