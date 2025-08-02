shader_type spatial;

void fragment() {
    float dist = 0.0;
	
	if (VERTEX.y > 0.0 && VERTEX.x < 0.0) {
		dist = VERTEX.y - VERTEX.x;
	}
	if (VERTEX.y < 0.0 && VERTEX.x < 0.0) {
		dist = -VERTEX.y - VERTEX.x;
	}
	if (VERTEX.y > 0.0 && VERTEX.x > 0.0) {
		dist = VERTEX.y + VERTEX.x;
	}
		if (VERTEX.y < 0.0 && VERTEX.x > 0.0) {
		dist = -VERTEX.y + VERTEX.x;
	}

    if (int(dist - TIME * 2.0) % 5 == 0) {
        ALBEDO = vec3(0.4, 0.9, 0.5); 
    } else {
        ALBEDO = vec3(0.2, 0.8, 0.3);
    }
}
//Looks cool: dist = VERTEX.y * VERTEX.x;
