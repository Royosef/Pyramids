# pyramid.gd

extends Spatial

const rotation_speed = .2

var mesh_transform: Transform
var basis_before_roll: Basis
var rotation_axis: Vector3

var is_forward = true

const edge = sqrt(3)
const height = sqrt(2)
const angle = PI - atan(2 * height)
const radius = 1
const base_width = edge
const base_height = 1.5 * radius
const z_vertical_offset = base_height * 2/3
const x_horizontal_offset = edge * 0.5
const z_horizontal_offset = base_height * 1/3
const z_pivot_vertical_offset = -height * 0.25
const x_pivot_vertical_offset = edge / 3


var forward_right_roll_info = RollInfo.new(
	Vector3(x_horizontal_offset,0,-z_horizontal_offset), 
	Vector3(-x_pivot_vertical_offset,z_pivot_vertical_offset,0), 
	Vector3(PI, PI/6, 0),
	Vector3(0,0,1), 
	1
)
var backward_right_roll_info = RollInfo.new(
	Vector3(x_horizontal_offset,0,z_horizontal_offset), 
	Vector3(-x_pivot_vertical_offset,z_pivot_vertical_offset,0), 
	Vector3(-PI, -PI/6, 0),
	Vector3(0,0,1), 
	1
)
var forward_left_roll_info = RollInfo.new(
	Vector3(-x_horizontal_offset,0,-z_horizontal_offset), 
	Vector3(x_pivot_vertical_offset,z_pivot_vertical_offset,0), 
	Vector3(-PI, -PI/6, 0),
	Vector3(0,0,1), 
	-1
)
var backward_left_roll_info = RollInfo.new(
	Vector3(-x_horizontal_offset,0,z_horizontal_offset), 
	Vector3(x_pivot_vertical_offset,z_pivot_vertical_offset,0), 
	Vector3(PI, PI/6, 0),
	Vector3(0,0,1), 
	-1
)
var down_roll_info = RollInfo.new(
	Vector3(0,0,z_vertical_offset), 
	Vector3(0,z_pivot_vertical_offset,-base_height * 1/3), 
	Vector3(0, 0, 0),
	Vector3(1,0,0), 
	1
)
var up_roll_info = RollInfo.new(
	Vector3(0,0,-z_vertical_offset), 
	Vector3(0,z_pivot_vertical_offset,base_height * 1/3), 
	Vector3(0, 0, 0),
	Vector3(1,0,0), 
	-1
)

func _ready() -> void:
	print('edge ',edge)
	print('rotation_speed ',rotation_speed)
	print('height ',height)
	print('angle ',angle)
	print('radius ',radius)
	print('base_width ',base_width)
	print('base_height ', base_height)
	print('x_horizontal_offset ', x_horizontal_offset)
	print('z_horizontal_offset ', z_horizontal_offset)
	print('z_vertical_offset ', z_vertical_offset)
	pass

func _input(event) -> void:
	if !$PivotPoint/mesh/Tween.is_active():
		if event.is_action_pressed("ui_right"):
			roll(forward_right_roll_info if is_forward else backward_right_roll_info)
			is_forward = !is_forward
		if event.is_action_pressed("ui_left"):
			roll(forward_left_roll_info if is_forward else backward_left_roll_info)
			is_forward = !is_forward
		if event.is_action_pressed("ui_down") and is_forward:
			roll(down_roll_info)
			is_forward = !is_forward
		if event.is_action_pressed("ui_up") and !is_forward:
			roll(up_roll_info)
			is_forward = !is_forward
			
func roll(info: RollInfo) -> void:
	move(info.offset, info.pivotPosition, info.pivotRotation)
	tween_rotate(info.axis, info.direction)
	
func move(offset: Vector3, pivotPosition: Vector3, pivotRotation: Vector3) -> void:
	
	mesh_transform = $PivotPoint/mesh.global_transform
	translate(offset)
	$PivotPoint.translation = pivotPosition
	$PivotPoint.rotation = pivotRotation
	$PivotPoint/mesh.global_transform = mesh_transform
	pass
	
func tween_rotate(axis: Vector3, direction: int) -> void:
	rotation_axis = axis
	basis_before_roll = $PivotPoint.transform.basis
	$PivotPoint/mesh/Tween.interpolate_method(self, "set_pivot_rotation",
		0, angle * direction, rotation_speed,
		Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$PivotPoint/mesh/Tween.start()

func set_pivot_rotation(rotation_angle) -> void:
	$PivotPoint.transform.basis = basis_before_roll
	$PivotPoint.rotate_object_local(rotation_axis, rotation_angle)

func _on_Tween_tween_all_completed() -> void:
	$PivotPoint/mesh.global_transform.origin = global_transform.origin
	pass
