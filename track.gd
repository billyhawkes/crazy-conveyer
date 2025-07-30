extends Node3D
class_name Track

const TRACK_POSITIONS: Array[Vector3] = [
	Vector3(0.0, 0.0, 0.0),
	Vector3(0.0, 0.0, 1.0),
	Vector3(0.0, 0.0, 2.0),
	Vector3(0.0, 0.0, 3.0),
	
	Vector3(1.0, 0.0, 3.0),
	Vector3(2.0, 0.0, 3.0),
	
	Vector3(3.0, 0.0, 3.0),
	Vector3(3.0, 0.0, 2.0),
	Vector3(3.0, 0.0, 1.0),
	Vector3(3.0, 0.0, 0.0),
	
	Vector3(2.0, 0.0, 0.0),
	Vector3(1.0, 0.0, 0.0),
]

func _ready() -> void:
	var index = get_index()
	global_position = TRACK_POSITIONS[index] * 2
	
