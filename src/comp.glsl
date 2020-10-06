uniform Image g1;
uniform Image g2;
uniform Image g3;
uniform vec3 matching[11];
uniform float light = 2.0; 
uniform float angle = 0;

uniform float sat = 0.9;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float AtoR(float x) {
	return 1.0 + x - sqrt(x*x + 2.0*x);
}

float blend(float x, float a) {
	float b = 1.0 - exp(-5.0*a*((1.0/x) - 0.5*x));
	//float b = 1.0 - exp(-6.0*a*(exp(-1.5*(x-1.0))));
	return b*x + (1.0-b)*0.4;
}


vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
{
	//vec2 coord = (TransformMatrix*vec4(screen_coords,0,1)).xy/love_ScreenSize.xy;
	vec2 coord = screen_coords/love_ScreenSize.xy;
	//vec2 coord = texture_coords;

	//multiply matching functions with spectrum to get col in XYZ
	vec3 col = vec3(0.0,0.0,0.0);
	vec4 c1 = Texel(g1, coord);
	vec4 c2 = Texel(g2, coord);
	vec4 c3 = Texel(g3, coord);

	float c = c3.a;

	col += blend(AtoR(c1.r/c),c)*matching[0];
	col += blend(AtoR(c1.g/c),c)*matching[1];
	col += blend(AtoR(c1.b/c),c)*matching[2];
	col += blend(AtoR(c1.a/c),c)*matching[3];
	col += blend(AtoR(c2.r/c),c)*matching[4];
	col += blend(AtoR(c2.g/c),c)*matching[5];
	col += blend(AtoR(c2.b/c),c)*matching[6];
	col += blend(AtoR(c2.a/c),c)*matching[7];
	col += blend(AtoR(c3.r/c),c)*matching[8];
	col += blend(AtoR(c3.g/c),c)*matching[9];
	col += blend(AtoR(c3.b/c),c)*matching[10];

	/*col += AtoR(c1.r)*matching[0];
	col += AtoR(c1.g)*matching[1];
	col += AtoR(c1.b)*matching[2];
	col += AtoR(c1.a)*matching[3];
	col += AtoR(c2.r)*matching[4];
	col += AtoR(c2.g)*matching[5];
	col += AtoR(c2.b)*matching[6];
	col += AtoR(c2.a)*matching[7];
	col += AtoR(c3.r)*matching[8];
	col += AtoR(c3.g)*matching[9];
	col += AtoR(c3.b)*matching[10];*/


	//lighting
	
	float x1 = Texel(g3, (screen_coords+vec2(-1.0,0.0))/love_ScreenSize.xy).a;
	float y1 = Texel(g3, (screen_coords+vec2(0.0,-1.0))/love_ScreenSize.xy).a;
	float x2 = Texel(g3, (screen_coords+vec2(1.0,0.0))/love_ScreenSize.xy).a;
	float y2 = Texel(g3, (screen_coords+vec2(0.0,1.0))/love_ScreenSize.xy).a;
	vec3 n = vec3(x1-x2,y1-y2,light);
	n = normalize(n);
	float l = dot(n,normalize(vec3(-sin(angle),-cos(angle),1)));
	col = col*l*1.41;

	//reduce saturation slightly - to prevent color clipping
	//also because the softclipping later increases saturation
	float lum = col.y;
	col = vec3(lum*0.95047,lum,lum*1.08883)*(1.0-sat) + sat*col;

	//transform XYZ to RGB
	col =  vec3( 3.2404542*col.x -1.5371385*col.y -0.4985314*col.z,
	            -0.9692660*col.x +1.8760108*col.y +0.0415560*col.z,
	             0.0556434*col.x -0.2040259*col.y +1.0572252*col.z);



	//softclip colors out of srgb gamut
	//col = smoothstep(-0.05,1.034,col);
	col = smoothstep(-0.023,1.01,col);

	//convert sRGB
	//not necessary since gamma-correct is enabled
	//col = pow(col,vec3(1.0/2.2));

    return vec4(col,1.0);
}