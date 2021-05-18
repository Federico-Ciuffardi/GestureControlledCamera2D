extends Camera2D

# Configuration
export(float) var MAX_ZOOM = 4
export(float) var MIN_ZOOM = 0.16 

export(int,"disabled","pinch") var zoom_gesture = 1
export(int,"disabled","twist") var rotation_gesture = 1
export(int,"disabled","single_drag","multi_drag") var movement_gesture = 2

func set_position(p):
	var position_limit_right
	var position_limit_left
	var position_limit_top
	var position_limit_bottom
	var camera_size = get_camera_size()*zoom
	if anchor_mode == ANCHOR_MODE_FIXED_TOP_LEFT:
		position_limit_right  = limit_right - camera_size.x
		position_limit_left   = limit_left 
		position_limit_top    = limit_top
		position_limit_bottom = limit_bottom - camera_size.y
	elif anchor_mode ==  ANCHOR_MODE_DRAG_CENTER:
		position_limit_right  = limit_right  - camera_size.x/2
		position_limit_left   = limit_left   + camera_size.x/2
		position_limit_top    = limit_top    + camera_size.y/2
		position_limit_bottom = limit_bottom - camera_size.y/2
	if(position_limit_right < position_limit_left or position_limit_bottom < position_limit_top):
		return false
	position = p
	if(position.x > position_limit_right):
		position.x = position_limit_right
	if(position.x < position_limit_left):
		position.x = position_limit_left
	if(position.y < position_limit_top):
		position.y = position_limit_top
	if(position.y > position_limit_bottom):
		position.y = position_limit_bottom
	print(position)
	print("horizontal limits: ", position_limit_left," , ", position_limit_right )
	print("vertical limits: ", position_limit_top," , ", position_limit_bottom )
	return true


func _unhandled_input(e):
	if (e is InputEventMultiScreenDrag and  movement_gesture == 2
		or e is InputEventSingleScreenDrag and  movement_gesture == 1):
		_move(e)
	elif e is InputEventScreenTwist and rotation_gesture == 1:
		_rotate(e)
	elif e is InputEventScreenPinch and zoom_gesture == 1:
		_zoom(e)

# Given a a position on the camera returns to the corresponding global position
func camera2global(position):
	var camera_center = global_position + position
	var from_camera_center_pos = position - get_camera_center_offset()
	return camera_center + (from_camera_center_pos*zoom).rotated(rotation)

func _move(event):
	set_position(position - (event.relative*zoom).rotated(rotation))

func _zoom(event):
	var li = event.distance
	var lf = event.distance + event.relative
	var zi = zoom.x
	
	var zf = (li*zi)/lf
	if zf == 0: return
	var zd = zf - zi
	
	if zf <= MIN_ZOOM and sign(zd) < 0:
		zf =MIN_ZOOM
		zd = zf - zi
	elif zf >= MAX_ZOOM and sign(zd) > 0:
		zf = MAX_ZOOM
		zd = zf - zi
	
	var from_camera_center_pos = event.position - get_camera_center_offset()
	zoom = zf*Vector2.ONE
	if(!set_position(position - (from_camera_center_pos*zd).rotated(rotation))):
		zoom = zi*Vector2.ONE

func _rotate(event):
	var fccp = (event.position - get_camera_center_offset()) # from_camera_center_pos = fccp
	var fccp_op_rot =  -fccp.rotated(event.relative)
	set_position(position - ((fccp_op_rot + fccp)*zoom).rotated(rotation-event.relative))
	rotation -= event.relative

func get_camera_center_offset():
	if anchor_mode == ANCHOR_MODE_FIXED_TOP_LEFT:
		return Vector2.ZERO
	elif anchor_mode ==  ANCHOR_MODE_DRAG_CENTER:
		return get_camera_size()/2

func get_camera_size():
	return get_viewport().get_visible_rect().size
