class_name RollInfo

var offset: Vector3
var pivotPosition: Vector3
var pivotRotation: Vector3
var axis: Vector3
var direction: int

func _init(offset: Vector3, pivotPosition: Vector3, pivotRotation: Vector3, axis: Vector3, direction: int) -> void:
	self.offset = offset
	self.pivotPosition = pivotPosition
	self.pivotRotation = pivotRotation
	self.axis = axis
	self.direction = direction
	
	pass
