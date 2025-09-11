uniform float spectrum[11];
uniform float pres;
uniform float alpha;
uniform Image g1;
uniform Image g2;
uniform Image g3;

//uniform float opaque = 0.9;


uniform Image MainTex;


float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

float RtoA(float x) {
	return ((1.0-x)*(1.0-x))/(2.0*x);
}

float AtoR(float x) {
	return 1.0 + x - sqrt(x*x + 2.0*x);
}



void effect()
{
	float th = Texel(MainTex, VaryingTexCoord.xy).r;
	//a *= smoothstep(0.0,0.1,alpha);
	//float a = smoothstep(0.0,0.35,th*pres);

	th = alpha*smoothstep(0.0,0.2,th + 1.0*(pres - 1));
	//th = 0.25*smoothstep(1.0-alpha,1.0,th);



	float a  = clamp(th*3,0,1);
	th = clamp(th,0,1);
	
	
	vec4 s1 = Texel(g1, (love_PixelCoord)/love_ScreenSize.xy);
	vec4 s2 = Texel(g2, (love_PixelCoord)/love_ScreenSize.xy);
	vec4 s3 = Texel(g3, (love_PixelCoord)/love_ScreenSize.xy);

	vec4 tr0 = (1.0-a)*s1 + th*vec4(RtoA(spectrum[0]),RtoA(spectrum[1]),RtoA(spectrum[2]),RtoA(spectrum[3]));
    vec4 tr1 = (1.0-a)*s2 + th*vec4(RtoA(spectrum[4]),RtoA(spectrum[5]),RtoA(spectrum[6]),RtoA(spectrum[7]));
    vec4 tr2 = (1.0-a)*s3 + th*vec4(RtoA(spectrum[8]),RtoA(spectrum[9]),RtoA(spectrum[10]),1.0);


    love_Canvases[0] = tr0;
    love_Canvases[1] = tr1;
    love_Canvases[2] = tr2;
}
