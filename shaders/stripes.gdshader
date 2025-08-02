shader_type spatial;

void fragment() {
	if (int(VERTEX.x + TIME * 2.0) % 5 == 1) {
		ALBEDO = vec3(0.4, 0.9, 0.5);
	} else {
		ALBEDO = vec3(0.2, 0.8, 0.3);
	}
}
