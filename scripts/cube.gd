# cube.gd

extends Spatial

var rotation_speed = .1

var mesh_transform: Transform
var basis_before_roll: Basis
var rotation_axis: Vector3

func _input(event) -> void:
	if !$PivotPoint/mesh/Tween.is_active():
		if event.is_action_pressed("ui_right"):
			roll(Vector3(2,0,0), Vector3(-1,-1,0), Vector3(0,0,1), -1)
		if event.is_action_pressed("ui_left"):
			roll(Vector3(-2,0,0), Vector3(1,-1,0), Vector3(0,0,1), 1)
		if event.is_action_pressed("ui_down"):
			roll(Vector3(0,0,2), Vector3(0,-1,-1), Vector3(1,0,0), 1)
		if event.is_action_pressed("ui_up"):
			roll(Vector3(0,0,-2), Vector3(0,-1,1), Vector3(1,0,0), -1)
			
func roll(offset: Vector3, pivotPosition: Vector3, axis: Vector3, direction: int) -> void:
	move(offset, pivotPosition)
	tween_rotate(axis, direction)
	
func move(offset: Vector3, pivotPosition: Vector3) -> void:
	mesh_transform = $PivotPoint/mesh.global_transform
	translate(offset)
	$PivotPoint.translation = pivotPosition
	$PivotPoint.rotation = Vector3(0, 0, 0)
	$PivotPoint/mesh.global_transform = mesh_transform
			
func tween_rotate(axis: Vector3, direction: int) -> void:
	rotation_axis = axis
	basis_before_roll = $PivotPoint.transform.basis
	$PivotPoint/mesh/Tween.interpolate_method(self, "set_pivot_rotation",
								0, PI/2 * direction, rotation_speed,
								Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$PivotPoint/mesh/Tween.start()       

func set_pivot_rotation(rotation_angle) -> void:
	$PivotPoint.transform.basis = basis_before_roll
	$PivotPoint.rotate_object_local(rotation_axis, rotation_angle)

func _on_Tween_tween_all_completed() -> void:
	$PivotPoint/mesh.global_transform.origin = global_transform.origin
	pass
