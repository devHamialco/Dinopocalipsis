shader_type spatial;

uniform sampler2D albedo_texture : source_color;
uniform vec4 albedo_color : source_color = vec4(1.0);
uniform float roughness : hint_range(0, 1) = 1.0;
uniform float metallic : hint_range(0, 1) = 0.0;
uniform vec4 emission : source_color = vec4(0.0);
uniform float emission_energy = 1.0;
uniform float flap_speed = 4.0;
uniform float flap_amount = 0.3;

void vertex() {
	// Rotar vértices alrededor del eje Z basado en qué tan lejos están
	// del centro en X — así las puntas de las alas se mueven más que el cuerpo
	float extent = abs(VERTEX.x);
	float angle = sin(TIME * flap_speed) * flap_amount * extent;
	float c = cos(angle);
	float s = sin(angle);
	float x = VERTEX.x;
	float y = VERTEX.y;
	VERTEX.x = x * c - y * s;
	VERTEX.y = x * s + y * c;
}

void fragment() {
	vec4 tex = texture(albedo_texture, UV);
	ALBEDO = tex.rgb * albedo_color.rgb;
	ALPHA = tex.a * albedo_color.a;
	ROUGHNESS = roughness;
	METALLIC = metallic;
	EMISSION = emission.rgb * emission_energy;
}
