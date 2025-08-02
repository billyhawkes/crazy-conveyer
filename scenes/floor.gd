extends MeshInstance3D

func _ready() -> void:
	_set_shader(Globals.levels.speed)
	Events.game.speed_changed.connect(_set_shader)
	

func _set_shader(speed: int):
	var shader_material := get_active_material(0) as ShaderMaterial
	print("MATERIAL", shader_material)
	if shader_material:
		shader_material.set_shader_parameter("speed", 1.0 + (speed / 2.0))
