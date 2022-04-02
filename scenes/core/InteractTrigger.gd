class_name InteractTrigger
extends Area

signal interacted_with(who)
signal text_changed

export(bool) var active = true setget activate
export(bool) var show_interactive_box = true setget update_interactive_box_visibility
export(String) var hover_text = "interact with"
export(float) var cooldown := 0.0

func _ready() -> void:
	if cooldown > 0.0:
		$Cooldown.wait_time = cooldown

func interact_with(who) -> void:
	emit_signal("interacted_with", who)
	if cooldown > 0.0:
		activate(false)
		$Cooldown.start()

func change_text(text: String) -> void:
	if hover_text != text:
		hover_text = text
		emit_signal("text_changed")

func activate(is_active: bool) -> void:
	collision_layer = 3 if is_active else 0
	visible = is_active

func update_interactive_box_visibility(is_box_visible: bool) -> void:
	show_interactive_box = is_box_visible
	$MeshInstance.visible = show_interactive_box

func _on_Cooldown_timeout() -> void:
	activate(true)

func hover() -> void:
	$MeshInstance.show()

func exit() -> void:
	$MeshInstance.hide()
