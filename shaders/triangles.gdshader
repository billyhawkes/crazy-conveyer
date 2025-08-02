shader_type spatial;

void fragment() {
    float dist = abs(VERTEX.x) + abs(VERTEX.z);

    if (int(dist - TIME) % 5 == 0) {
        ALBEDO = vec3(0.4, 0.9, 0.5); 
    } else {
        ALBEDO = vec3(0.2, 0.8, 0.3);
    }
}
