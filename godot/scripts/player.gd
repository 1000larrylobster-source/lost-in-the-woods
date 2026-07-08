extends CharacterBody3D
## Third-person controller — Session 1 is all about how this FEELS.
## Tune the numbers in the Inspector (or here), press F5, walk the trail.
## WASD / arrows to move, hold Shift to jog, Space for a small hop.
## Drag with the mouse (left or right button) to orbit the camera; scroll to zoom.

@export_group("Movement Feel")
@export var walk_speed := 6.5         ## m/s — cruising pace
@export var sprint_speed := 10.0      ## m/s — hold Shift
@export var acceleration := 16.0      ## how fast you reach full speed
@export var deceleration := 22.0      ## how fast you stop
@export var turn_smoothing := 9.0     ## visual turn rate (higher = snappier)
@export var jump_velocity := 4.5      ## small hop (Space)

@export_group("Camera Feel")
@export var mouse_sensitivity := 0.006
@export var cam_default_distance := 5.5
@export var cam_min_distance := 2.0
@export var cam_max_distance := 12.0
@export var cam_start_pitch_deg := -12.0
@export var pitch_min_deg := -55.0    ## looking down limit
@export var pitch_max_deg := 25.0     ## looking up limit

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _dragging := false

@onready var _yaw: Node3D = $CamYaw
@onready var _pitch: Node3D = $CamYaw/CamPitch
@onready var _arm: SpringArm3D = $CamYaw/CamPitch/SpringArm3D
@onready var _visual: Node3D = $Visual

func _ready() -> void:
	_arm.spring_length = cam_default_distance
	_arm.add_excluded_object(get_rid())
	_pitch.rotation.x = deg_to_rad(cam_start_pitch_deg)
	floor_snap_length = 0.8  # hug the terrain walking downhill

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT:
				_dragging = event.pressed
			MOUSE_BUTTON_WHEEL_UP:
				if event.pressed:
					_arm.spring_length = maxf(cam_min_distance, _arm.spring_length - 0.6)
			MOUSE_BUTTON_WHEEL_DOWN:
				if event.pressed:
					_arm.spring_length = minf(cam_max_distance, _arm.spring_length + 0.6)
	elif event is InputEventMouseMotion and _dragging:
		_yaw.rotate_y(-event.relative.x * mouse_sensitivity)
		_pitch.rotation.x = clampf(
			_pitch.rotation.x - event.relative.y * mouse_sensitivity,
			deg_to_rad(pitch_min_deg), deg_to_rad(pitch_max_deg))

func _physics_process(delta: float) -> void:
	var input := _move_input()
	# Move relative to where the CAMERA looks, not where the body faces.
	var direction := _yaw.global_transform.basis * Vector3(input.x, 0.0, input.y)
	direction.y = 0.0
	direction = direction.normalized() if direction.length() > 0.01 else Vector3.ZERO

	var target_speed := sprint_speed if Input.is_physical_key_pressed(KEY_SHIFT) else walk_speed
	var horizontal := Vector3(velocity.x, 0.0, velocity.z)
	if direction != Vector3.ZERO:
		horizontal = horizontal.move_toward(direction * target_speed, acceleration * delta)
	else:
		horizontal = horizontal.move_toward(Vector3.ZERO, deceleration * delta)
	velocity.x = horizontal.x
	velocity.z = horizontal.z

	if is_on_floor():
		if Input.is_physical_key_pressed(KEY_SPACE):
			velocity.y = jump_velocity
	else:
		velocity.y -= _gravity * delta

	move_and_slide()

	# Face where you're going (smoothed) — the character turns, the camera doesn't.
	if horizontal.length() > 0.6:
		var target_yaw := atan2(-horizontal.x, -horizontal.z)
		_visual.rotation.y = lerp_angle(_visual.rotation.y, target_yaw, minf(turn_smoothing * delta, 1.0))

func _move_input() -> Vector2:
	var v := Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_W) or Input.is_physical_key_pressed(KEY_UP):
		v.y -= 1.0
	if Input.is_physical_key_pressed(KEY_S) or Input.is_physical_key_pressed(KEY_DOWN):
		v.y += 1.0
	if Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT):
		v.x -= 1.0
	if Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT):
		v.x += 1.0
	return v.normalized() if v.length() > 1.0 else v
