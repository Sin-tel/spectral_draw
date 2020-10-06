uniform Image g;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
	/*float c = Texel(tex, texture_coords).r;
	float x1 = Texel(tex, texture_coords + vec2(1.0,0.0)/60).r;
	float x2 = Texel(tex, texture_coords + vec2(-1.0,0.0)/60).r;
	float y1 = Texel(tex, texture_coords + vec2(0.0,1.0)/60).r;
	float y2 = Texel(tex, texture_coords + vec2(0.0,-1.0)/60).r;
	float d = 4*c - (x1+x2+y1+y2);
	float a = smoothstep(0.08,0.2,d);*/
	float r = 2.0*length(texture_coords - vec2(0.5,0.5));

	float a = exp(-200.0*(r-0.8)*(r-0.8));
	float d = smoothstep(0.75,0.9,r);

    return vec4(vec3(d),a);
}