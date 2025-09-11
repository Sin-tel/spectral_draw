uniform Image g1;
uniform Image g2;
uniform Image g3;
uniform vec2 vel;

uniform float pres = 0.5;

uniform Image MainTex;

/*
params
d multiplier "distance"
a multiplier in clamp "strength"
knife mode: a = 0.98
scrape mode
*/

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


void effect()
{
	float amt = Texel(MainTex, VaryingTexCoord.xy).r;



    vec2 d = -vel*smoothstep(0.0,0.2,amt + 0.6*(pres - 1));


    vec4 c3 = Texel(g3, (love_PixelCoord + d)/love_ScreenSize.xy);
    vec4 c3b = Texel(g3, (love_PixelCoord)/love_ScreenSize.xy);

    float a = c3.a/(c3.a + c3b.a + 0.0001);

    a *= smoothstep(0,0.05,c3.a);
    a = clamp(a*1.5,0,1);
    a = .98;

    //scrape
    //a = 0.02+0.98*smoothstep(0,0.2,c3b.a);
    


    love_Canvases[0] = a*Texel(g1, (love_PixelCoord + d)/love_ScreenSize.xy) + (1.0-a)*Texel(g1, love_PixelCoord/love_ScreenSize.xy);
    love_Canvases[1] = a*Texel(g2, (love_PixelCoord + d)/love_ScreenSize.xy) + (1.0-a)*Texel(g2, love_PixelCoord/love_ScreenSize.xy);
    love_Canvases[2] = a*c3 + (1.0-a)*c3b;

}
