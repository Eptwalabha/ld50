class_name Clock extends Spatial

onready var pivot := $Pivot

export(bool) var running := false

func _ready() -> void:
	reset_clock(!running)

func _process(delta: float) -> void:
	if running:
		pivot.global_rotate(Vector3(0.0, 0.0, 1.0), deg2rad(delta * 360.0 / 300.0))

func reset_clock(stop : bool = true) -> void:
	running = !stop
	pivot.rotation_degrees = Vector3(0.0, 0.0, 0.0)
