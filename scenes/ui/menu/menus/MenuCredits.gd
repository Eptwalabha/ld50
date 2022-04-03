extends GameSubMenu

onready var scroll : ScrollContainer = $Content/VBoxContainer/ScrollContainer
onready var tween_scroll : Tween = $Content/VBoxContainer/ScrollContainer/Tween

var small = true

const SCROLL_SPEED := 16

func _ready() -> void:
	var inputs = get_tree().get_nodes_in_group("credits-input")
	var size = len(inputs)
	for i in range(size):
		var previous = wrapi(i - 1, 0, size)
		var next = wrapi(i + 1, 0, size)
		inputs[i].focus_neighbour_left = inputs[i].get_path()
		inputs[i].focus_neighbour_right = inputs[i].get_path()
		inputs[i].focus_neighbour_top = inputs[previous].get_path()
		inputs[i].focus_neighbour_bottom = inputs[next].get_path()

func enter() -> void:
	.enter()

func process(delta: float) -> void:
	.process(delta)
	if Input.is_action_pressed("look_down") or Input.is_action_pressed("look_up"):
		var x = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
		scroll.scroll_vertical += int(x * SCROLL_SPEED)

func input(event: InputEvent) -> void:
	.input(event)
	if event.is_action_pressed("ui_down", true):
		tween_scroll.interpolate_property(
				scroll, "scroll_vertical",
				scroll.scroll_vertical, scroll.scroll_vertical + 32, .1)
		tween_scroll.start()
	elif event.is_action_pressed("ui_up", true):
		tween_scroll.interpolate_property(
				scroll, "scroll_vertical",
				scroll.scroll_vertical, scroll.scroll_vertical - 32, .1)
		tween_scroll.start()

func _on_Content_item_rect_changed() -> void:
	var is_small_size = $Content.rect_size.x < 1024
	if is_small_size != small:
		small = is_small_size
		var nbr_columns = 1 if small else 2
		$Content/VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/Xelu/Header.columns = nbr_columns
		$Content/VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/Font/Header.columns = nbr_columns
		$Content/VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/Other/Header.columns = nbr_columns

func _on_FontDL_pressed() -> void:
	OS.shell_open("https://www.ffonts.net/Vollkorn-Black.font")

func _on_Download_xelu_pack_pressed() -> void:
	OS.shell_open("https://thoseawesomeguys.com/prompts/")

func _on_Youtube_xelu_chanel_pressed() -> void:
	OS.shell_open("https://www.youtube.com/watch?v=d6GtGbI-now")

