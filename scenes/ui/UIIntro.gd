class_name UIIntro extends Control

signal faded_out
signal next_level_requested

onready var anim : AnimationPlayer = $AnimationPlayer

var ready_to_fade_out : bool = false

func _ready() -> void:
	pass

func start(level_id: int) -> void:
	show()
	if Data.DEBUG:
		ready_to_fade_out = true
	else:
		$TextContainer/Action.hide()
		ready_to_fade_out = false
		anim.play("intro-in")
		$TextContainer/Title.text = "lvl_title_%d" % level_id
		$TextContainer/Text.text = "lvl_quote_%d" % level_id

func next_level() -> void:
	anim.play("outro-start")

func outro_ended() -> void:
	emit_signal("next_level_requested")

func _input(event: InputEvent) -> void:
	if ready_to_fade_out:
		if event.is_action_pressed("context_action") or event.is_action_pressed("ui_cancel"):
			ready_to_fade_out = false
			if Data.DEBUG:
				emit_signal("faded_out")
				hide()
			else:
				anim.play("intro-out")

func level_ready() -> void:
	$TextContainer/Action.show()
	ready_to_fade_out = true

