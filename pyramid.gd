# pyramid.gd

extends Spatial

var mesh_transform: Transform

var transform_before_roll
var rotation_axis

const rotation_speed = .1
const height = sqrt(2)
const angle = PI - atan(2 * height)
const radius = 1
const base_width = sqrt(3)
const base_height = radius * 1.5
var gg = height * sin(PI/2 - angle)
var hh = height * cos(PI/2 - angle)

func _ready() -> void:
	print('angle ',angle)
	print('height ',height)
	print('base_width ',base_width)
	print('base_height ', base_height)
	print('gg ', gg)
	print('hh ', hh)
	pass

func _input(event):
	if !$PivotPoint/mesh/Tween.is_active():
		if event.is_action_pressed("ui_right"):
			roll(Vector3(base_width,0,0), Vector3(-0.5,-height,0), Vector3(0,0,1), -1)
		if event.is_action_pressed("ui_left"):
			roll(Vector3(-base_width,0,0), Vector3(0.5,-height,0), Vector3(0,0,1), 1)
		if event.is_action_pressed("ui_down"):
			roll(Vector3(0,gg,hh), Vector3(0,-height,0), Vector3(1,0,0), 1)
		if event.is_action_pressed("ui_up"):
			roll(Vector3(0,-gg,-hh), Vector3(0,-height,0), Vector3(1,0,0), -1)
			
func roll(offset: Vector3, pivotPosition: Vector3, axis: Vector3, direction: int):
	move(offset, pivotPosition)
#	set_pivot_side_rotation(1)
	$PivotPoint.rotate(Vector3(1,0,0), angle * direction)
	$PivotPoint/mesh.global_transform.origin = global_transform.origin
	#tween_rotate(axis, direction)
	
func move(offset: Vector3, pivotPosition: Vector3):
	mesh_transform = $PivotPoint/mesh.global_transform
	translate(offset)
	$PivotPoint.translation = pivotPosition
	$PivotPoint.rotate_x(-1 * PI)
	$PivotPoint.rotate_y(-PI/6)
	$PivotPoint/mesh.global_transform = mesh_transform
	pass
			
#func tween_rotate(axis: Vector3, direction: int):
#	rotation_axis = axis
#	transform_before_roll = $PivotPoint.transform.basis
#	$PivotPoint/mesh/Tween.interpolate_method(self, "set_pivot_side_rotation",
#								0, radius, rotation_speed,
#								Tween.TRANS_SINE, Tween.EASE_IN_OUT)
#	$PivotPoint/mesh/Tween.start()      
	
func tween_rotate(axis: Vector3, direction: int):
	rotation_axis = axis
	transform_before_roll = $PivotPoint.transform.basis
	$PivotPoint/mesh/Tween.interpolate_method(self, "set_pivot_rotation",
								0, angle * direction, rotation_speed,
								Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$PivotPoint/mesh/Tween.start()

func set_pivot_rotation(rotation_angle):
	$PivotPoint.transform.basis = transform_before_roll
	$PivotPoint.rotate(rotation_axis, rotation_angle)

func _on_Tween_tween_all_completed():
	$PivotPoint/mesh.global_transform.origin = global_transform.origin
	pass

func set_pivot_side_rotation(z):
	var x = sqrt(3) * z
	var xAngle = atan(-1 * height / x)
	var zAngle = atan(-1 * height / z)
	
	#$PivotPoint.transform.basis = transform_before_roll
	$PivotPoint.rotate(Vector3(1,0,0), xAngle)
	$PivotPoint.rotate(Vector3(0,0,1), zAngle)
	pass
