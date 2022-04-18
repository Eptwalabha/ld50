class_name ScreenTransition extends ColorRect

signal fade_in_ended
signal fade_out_ended

onready var anim : AnimationPlayer = $AnimationPlayer

func fade_in() -> void:
	anim.play("fade-in")

func fade_out() -> void:
	anim.play("fade-out")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match anim_name:
		"fade-in":
			emit_signal("fade_in_ended")
		"fade-out":
			emit_signal("fade_out_ended")
