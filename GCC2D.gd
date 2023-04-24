extends Camera2D

# Configuration
@export var MAX_ZOOM: float = 4
@export var MIN_ZOOM: float = 0.16 

enum ZOOM_GESTURE { DISABLED , PINCH }
enum ROTATE_GESTURE { DISABLED , TWIST }
enum MOVEMENT_GESTURE { DISABLED, SINGLE_DRAG, MULTI_DRAG }

@export var zoom_gesture : ZOOM_GESTURE = ZOOM_GESTURE.PINCH 
@export var rotation_gesture : ROTATE_GESTURE = ROTATE_GESTURE.TWIST
@export var movement_gesture : MOVEMENT_GESTURE = MOVEMENT_GESTURE.SINGLE_DRAG

func set_camera_position(p):
	var position_max_limit
	var position_min_limit
	var camera_size = get_camera_size()/zoom

	if anchor_mode == ANCHOR_MODE_FIXED_TOP_LEFT:
		position_max_limit = Vector2(limit_right, limit_bottom) - camera_size
		position_min_limit = Vector2(limit_left , limit_top)
	elif anchor_mode ==  ANCHOR_MODE_DRAG_CENTER:
		position_max_limit = Vector2(limit_right, limit_bottom) - camera_size/2
		position_min_limit = Vector2(limit_left , limit_top) + camera_size
  
	if(position_max_limit < position_min_limit):
		return false

	position = p

	if(position.x > position_max_limit.x):
		position.x = position_max_limit.x
	if(position.x < position_min_limit.x):
		position.x = position_min_limit.x
	if(position.y > position_max_limit.y):
		position.y = position_max_limit.y
	if(position.y < position_min_limit.y):
		position.y = position_min_limit.y

	return true


func _unhandled_input(e):
	if (e is InputEventMultiScreenDrag and  movement_gesture == 2
		or e is InputEventSingleScreenDrag and  movement_gesture == 1):
		_move(e)
	elif e is InputEventScreenTwist and rotation_gesture == 1:
		_rotate(e)
	elif e is InputEventScreenPinch and zoom_gesture == 1:
		_zoom(e)

func _get_rotation():
	if (ignore_rotation):
		return 0 
	return rotation

# Given a a position on the camera returns to the corresponding global position
func camera2global(position):
	var camera_center = global_position
	var from_camera_center_pos = position - get_camera_center_offset()
	return camera_center + (from_camera_center_pos/zoom).rotated(_get_rotation())

func _move(event):
	set_camera_position(position - (event.relative/zoom).rotated(_get_rotation()))

func _zoom(event):
	var li = event.distance
	var lf = event.distance - event.relative

	var zi = zoom.x
	var zf = (li*zi)/lf
	var zd = zf - zi
	
	if zf <= MIN_ZOOM and sign(zd) < 0:
		zf = MIN_ZOOM
		zd = zf - zi
	elif zf >= MAX_ZOOM and sign(zd) > 0:
		zf = MAX_ZOOM
		zd = zf - zi
	
	var from_camera_center_pos = event.position - get_camera_center_offset()
	zoom = zf*Vector2.ONE

	var relative = (from_camera_center_pos*zd) / (zi*zf) 
	if(!set_camera_position(position + relative.rotated(_get_rotation()))):
		zoom = zi*Vector2.ONE

func _rotate(event):
	if ignore_rotation:
		return
	var fccp = (event.position - get_camera_center_offset())
	var fccp_op_rot =  -fccp.rotated(event.relative)
	set_camera_position(position - ((fccp_op_rot + fccp)/zoom).rotated(rotation-event.relative))
	rotation -= event.relative

func get_camera_center_offset():
	if anchor_mode == ANCHOR_MODE_FIXED_TOP_LEFT:
		return Vector2.ZERO
	elif anchor_mode ==  ANCHOR_MODE_DRAG_CENTER:
		return get_camera_size()/2

func get_camera_size():
	return get_viewport().get_visible_rect().size
