class_name UIIntro extends Control

signal faded_out

var ready_to_fade_out : bool = false

func _ready() -> void:
	pass

func start(key_title, key_content) -> void:
	show()
	if Data.DEBUG:
		ready_to_fade_out = true
	else:
		$TextContainer/Action.hide()
		ready_to_fade_out = false
		$AnimationPlayer.play("intro-in")
		$TextContainer/Title.text = key_title
		$TextContainer/Text.text = key_content

func _input(event: InputEvent) -> void:
	if ready_to_fade_out:
		if event.is_action_pressed("context_action") or event.is_action_pressed("ui_cancel"):
			ready_to_fade_out = false
			if Data.DEBUG:
				emit_signal("faded_out")
				hide()
			else:
				$AnimationPlayer.play("intro-out")

func level_ready() -> void:
	$TextContainer/Action.show()
	ready_to_fade_out = true

