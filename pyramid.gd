# pyramid.gd

extends Spatial

var mesh_transform: Transform

var transform_before_roll
var rotation_axis

const edge = sqrt(3)
const rotation_speed = .5
const height = sqrt(2)
const angle = PI - atan(2 * height)
const radius = 1
const base_width = edge
const base_height = 1.5 * radius
const height_projection_y = height * sin(PI/2 - angle)
const height_projection_z = height * cos(PI/2 - angle)
const edge_cut_on_intersection = height_projection_z / 2 / cos(PI/6)
const side_translation_x = edge_cut_on_intersection * 1.5
const side_translation_z = edge_cut_on_intersection * 0.5 / tan(PI/6)

var dis = 0.02

func _ready() -> void:
	print('edge ',angle)
	print('rotation_speed ',rotation_speed)
	print('height ',height)
	print('angle ',angle)
	print('radius ',radius)
	print('base_width ',base_width)
	print('base_height ', base_height)
	print('height_projection_y ', height_projection_y)
	print('height_projection_z ', height_projection_z)
	print('side_translation_x ', side_translation_x)
	print('side_translation_z ', side_translation_z)
	
	pass

func _input(event):
	if !$PivotPoint/mesh/Tween.is_active():
		if event.is_action_pressed("ui_right"):
			roll(Vector3(side_translation_x,height_projection_y,-side_translation_z), Vector3(0.5,-height,0), Vector3(0,0,1), 1)
		if event.is_action_pressed("ui_left"):
			roll(Vector3(-side_translation_x,height_projection_y,-side_translation_z), Vector3(-0.5,-height,0), Vector3(0,0,1), -1)
		if event.is_action_pressed("ui_down"):
			roll(Vector3(0,height_projection_y,height_projection_z), Vector3(0,-height,0), Vector3(1,0,0), 1)
		if event.is_action_pressed("ui_up"):
			roll(Vector3(0,-height_projection_y,-height_projection_z), Vector3(0,-height,0), Vector3(1,0,0), -1)
		if Input.is_key_pressed(KEY_KP_8):
			translate(Vector3(0,0,-dis))
		if Input.is_key_pressed(KEY_KP_2):
			translate(Vector3(0,0,dis))
		if Input.is_key_pressed(KEY_KP_4):
			translate(Vector3(-dis,0,0))
		if Input.is_key_pressed(KEY_KP_6):
			translate(Vector3(dis,0,0))
		if Input.is_key_pressed(KEY_KP_ADD):
			translate(Vector3(0,dis,0))
		if Input.is_key_pressed(KEY_KP_SUBTRACT):
			translate(Vector3(0,-dis,0))
		if Input.is_key_pressed(KEY_P):
			print(translation)
			
func roll(offset: Vector3, pivotPosition: Vector3, axis: Vector3, direction: int):
	move(offset, pivotPosition)

#	$PivotPoint.rotate_object_local(axis, angle * direction)
#	$PivotPoint/mesh.global_transform.origin = global_transform.origin
	
	tween_rotate(axis, direction)
	
func move(offset: Vector3, pivotPosition: Vector3):
	mesh_transform = $PivotPoint/mesh.global_transform
	translate(offset)
	$PivotPoint.translation = pivotPosition
	$PivotPoint.rotate_x(-1 * PI)
	$PivotPoint.rotate_y(-PI/6)
	$PivotPoint/mesh.global_transform = mesh_transform
	pass
	
func tween_rotate(axis: Vector3, direction: int):
	rotation_axis = axis
	transform_before_roll = $PivotPoint.transform.basis
	$PivotPoint/mesh/Tween.interpolate_method(self, "set_pivot_rotation",
		0, angle * direction, rotation_speed,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$PivotPoint/mesh/Tween.start()

func set_pivot_rotation(rotation_angle):
	$PivotPoint.transform.basis = transform_before_roll
	$PivotPoint.rotate_object_local(rotation_axis, rotation_angle)

func _on_Tween_tween_all_completed():
	$PivotPoint/mesh.global_transform.origin = global_transform.origin
	pass
