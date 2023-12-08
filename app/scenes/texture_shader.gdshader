shader_type spatial;

uniform sampler2D terrain_grass;
uniform sampler2D terrain_gravel;
uniform float min_grass_height = -0.30;
uniform float max_gravel_height = 1.6;
varying float vertex_y;
uniform vec2 uvscale = vec2(20);

void fragment() {
	float vert_height = vertex_y;
	
	vec3 grass = texture(terrain_grass,UV*uvscale).rgb;
	vec3 gravel = texture(terrain_gravel,UV*uvscale).rgb;
	
	float weight = smoothstep(min_grass_height,max_gravel_height,vert_height);
	
	vec3 final_color = mix(grass,gravel,weight);
	
	ALBEDO = final_color.rgb;
}

void vertex(){
	vertex_y = VERTEX.y;
}

