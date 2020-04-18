extends Spatial

var cameraIndex = 0
onready var camerasCount := count_nodes(Camera)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_focus_next"):
		cameraIndex += 1
		cameraIndex %= camerasCount
		get_node("Camera%s"%cameraIndex).current = true

func count_nodes(type) -> int:
	var count = 0
	
	for node in get_children():
		if(node is type):
			count += 1

	return count
