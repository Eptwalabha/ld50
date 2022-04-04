class_name Clock extends Spatial

onready var pivot := $Pivot

export(bool) var running := false
var time_amount : float = 10.0
var acc : float = 0.0

func _ready() -> void:
	reset(running)

func _process(delta: float) -> void:
	if running:
		acc += delta
		pivot.rotation = Vector3(0.0, 0.0, TAU * acc / time_amount)
#		pivot.rotate(Vector3(0.0, 0.0, 1.0), deg2rad(delta * 360.0 / 300.0))

func reset(is_running : bool = true) -> void:
	running = is_running
	acc = 0.0
	pivot.rotation_degrees = Vector3(0.0, 0.0, 0.0)

func start(time: float) -> void:
	time_amount = time
	reset(true)
