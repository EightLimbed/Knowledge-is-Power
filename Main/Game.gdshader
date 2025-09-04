shader_type canvas_item;

global uniform vec2 player_pos;
const vec2 screen_center = vec2(480,180);

void fragment() {
	float dist = distance(FRAGCOORD.xy,screen_center-player_pos/10.0);
	dist += sin(atan(FRAGCOORD.y/FRAGCOORD.x*100.0));
	COLOR = vec4(vec3(dist/640.0),1.0);
}
