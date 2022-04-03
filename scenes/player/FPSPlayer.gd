class_name FPSPlayer
extends KinematicBody

signal interact_hovered(area)
signal interact_exited(area)
signal land(velocity)

export(float) var speed := 4.0
export(float) var air_speed = 4.0
export(float) var acceleration := 10.0
export(float) var air_acceleration := acceleration * .2

onready var head := $Head as Spatial
onready var camera := $Head/Camera as Camera
onready var interact_ray := $Head/Camera/Ray as RayCast
onready var jump_sound := $Jump as AudioStreamPlayer
onready var crosshair := $Crosshair

var has_control : bool = true
var camera_angle : float = 0.0
var velocity := Vector3()
var new_velocity := Vector3()

var _current_interact: InteractTrigger
var _direction: Vector3 = Vector3.ZERO
var _jump: bool = false
var _transition_time: float = 0.0
const TRANSITION_TIME := 0.2

enum STATE {
	ON_GROUND,
	TRANSITION,
	IN_AIR
}

var _state = STATE.ON_GROUND

func _ready() -> void:
	Data.connect("crosshair_visibility_changed", self, "display_crosshair")
	Data.connect("fov_changed", self, "set_fov")

func reset() -> void:
	head.rotation = Vector3.ZERO
	camera.rotation = Vector3.ZERO
	zeroed_velocity()
	camera_angle = 0

func zeroed_velocity() -> void:
	velocity = Vector3.ZERO

func _input(event: InputEvent) -> void:
	if not has_control:
		return

	if can_jump() and event.is_action_pressed("move_jump"):
		_jump = true

	if event is InputEventMouseMotion:
		Data.using_controller = false
		head.rotate_y(deg2rad(event.relative.x * -Data.MOUSE_SENSITIVITY * .5))

		var y = -1 if Data.MOUSE_INVERT_Y else 1
		var change = event.relative.y * -Data.MOUSE_SENSITIVITY * .5 * y
		if change + camera_angle < 90 and change + camera_angle > -90:
			camera.rotate_x(deg2rad(change))
			camera_angle = camera_angle + change
	if event is InputEventJoypadMotion or event is InputEventJoypadButton:
		Data.using_controller = true

func input_controller() -> void:
	if Data.using_controller:
		var y = (Input.get_action_strength("look_left") - Input.get_action_strength("look_right")) \
				* Data.MOUSE_SENSITIVITY * 10
		head.rotate_y(deg2rad(y))
		var x = - (Input.get_action_strength("look_down") - Input.get_action_strength("look_up")) \
				* Data.MOUSE_SENSITIVITY * 10
		if Data.MOUSE_INVERT_Y:
			x = -x
		if x + camera_angle < 90 and x + camera_angle > -90:
			camera.rotate_x(deg2rad(x))
			camera_angle = camera_angle + x

	_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	_direction.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")

func _physics_process(delta: float) -> void:
	_direction = Vector3.ZERO

	if has_control:
		input_controller()
		if _direction.length() > 1.0:
			_direction = _direction.normalized()
		_direction = head.global_transform.basis.xform(_direction)

	if _state == STATE.IN_AIR:
		_physics_process_in_air(delta, _direction)
	else:
		_physics_process_on_ground(delta, _direction)

func _physics_process_on_ground(delta: float, direction: Vector3) -> void:
	velocity = lerp(velocity, direction * speed, acceleration * delta)

	if _jump:
		_jump = false
		jump_sound.play()
		_state = STATE.IN_AIR
		velocity += get_floor_velocity() * delta
		velocity.y += Data.JUMP_HIGHT
		velocity = move_and_slide(velocity, Vector3.UP)
	else:
		velocity = move_and_slide_with_snap(velocity, Vector3.DOWN, Vector3.UP, true, 6, Data.MAX_SLOP)
		update_physic_state(delta)


func _physics_process_in_air(delta: float, direction: Vector3) -> void:
	_jump = false
	var ratio = clamp(velocity.normalized().dot(direction) * -1.0 + 1.0, 0.0, 1.0)
	velocity += lerp(Vector3.ZERO, direction * air_speed * ratio, air_acceleration * delta)
	velocity += Vector3.DOWN * Data.GRAVITY * delta
	new_velocity = move_and_slide(velocity, Vector3.UP)
	update_physic_state(delta)
	velocity = new_velocity

func can_jump() -> bool:
	return _state != STATE.IN_AIR

func update_physic_state(delta: float) -> void:
	match _state:
		STATE.IN_AIR:
			if is_on_floor():
				_state = STATE.ON_GROUND
				emit_signal("land", velocity)
		STATE.TRANSITION:
			_transition_time += delta
			if _transition_time > TRANSITION_TIME:
				_state = STATE.IN_AIR
		STATE.ON_GROUND:
			if not is_on_floor():
				_state = STATE.TRANSITION
				_transition_time = 0.0

func interact_with() -> void:
	if _current_interact is InteractTrigger:
		_current_interact.interact_with(self)
		_current_interact = null

func _on_Ray_area_entered(area) -> void:
	if area is InteractTrigger:
		_current_interact = area
		emit_signal("interact_hovered", _current_interact)

func _on_Ray_area_exited() -> void:
	if _current_interact is InteractTrigger:
		emit_signal("interact_exited", _current_interact)
	_current_interact = null

func _on_Timer_timeout() -> void:
	if interact_ray.is_colliding():
		var collider = interact_ray.get_collider()
		if collider is InteractTrigger:
			if collider != _current_interact:
				_on_Ray_area_entered(collider)
		else:
			_on_Ray_area_exited()
	elif _current_interact != null:
		_on_Ray_area_exited()

func display_crosshair(visible: bool) -> void:
	crosshair.visible = visible

func set_fov(new_fov: float) -> void:
	camera.fov = new_fov

