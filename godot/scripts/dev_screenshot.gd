extends Node
## Autoload: the machine's eye.
## Run the game with `-- --screenshot-mode` and this waits 2 seconds,
## saves the viewport to /tmp/godot-shot.png, and quits.
## Lets the machine SEE the game headlessly between edits.
##
##   /Applications/Godot.app/Contents/MacOS/Godot --path godot/ -- --screenshot-mode

const SHOT_PATH := "/tmp/godot-shot.png"
const SETTLE_SECONDS := 2.0

var _walking := false

func _ready() -> void:
	var args := OS.get_cmdline_user_args()
	if "--screenshot-mode" in args:
		_walking = "--walk" in args
		_take_screenshot()

func _physics_process(_delta: float) -> void:
	if _walking:
		# Re-press a synthetic W every frame (window focus events clear
		# injected key state) so the shot proves the controller moves.
		var ev := InputEventKey.new()
		ev.physical_keycode = KEY_W
		ev.pressed = true
		Input.parse_input_event(ev)

func _take_screenshot() -> void:
	await get_tree().create_timer(SETTLE_SECONDS).timeout
	await RenderingServer.frame_post_draw
	var player := get_node_or_null("/root/Valley/Player")
	if player:
		print("dev_screenshot: player at ", player.global_position)
	var img := get_viewport().get_texture().get_image()
	var err := img.save_png(SHOT_PATH)
	if err == OK:
		print("dev_screenshot: saved ", SHOT_PATH)
	else:
		printerr("dev_screenshot: FAILED to save ", SHOT_PATH, " err=", err)
	get_tree().quit()
