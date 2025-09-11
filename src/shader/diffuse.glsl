uniform Image g1;
uniform Image g2;
uniform Image g3;
uniform vec2 offset;
uniform float time;
uniform vec2 pos;


vec2 hash( in vec2 x )  // replace this by something better
{
    const vec2 k = vec2( 0.3183099, 0.3678794 );
    x = x*k + k.yx;
    return -1.0 + 2.0*fract( 16.0 * k*fract( x.x*x.y*(x.x+x.y)) );
}
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
vec3 noised( in vec2 p )
{
    vec2 i = floor( p );
    vec2 f = fract( p );

    vec2 u = f*f*f*(f*(f*6.0-15.0)+10.0);
    vec2 du = 30.0*f*f*(f*(f-2.0)+1.0);
    
    vec2 ga = hash( i + vec2(0.0,0.0) );
    vec2 gb = hash( i + vec2(1.0,0.0) );
    vec2 gc = hash( i + vec2(0.0,1.0) );
    vec2 gd = hash( i + vec2(1.0,1.0) );
    
    float va = dot( ga, f - vec2(0.0,0.0) );
    float vb = dot( gb, f - vec2(1.0,0.0) );
    float vc = dot( gc, f - vec2(0.0,1.0) );
    float vd = dot( gd, f - vec2(1.0,1.0) );

    return vec3( va + u.x*(vb-va) + u.y*(vc-va) + u.x*u.y*(va-vb-vc+vd),   // value
                 ga + u.x*(gb-ga) + u.y*(gc-ga) + u.x*u.y*(ga-gb-gc+gd) +  // derivatives
                 du * (u.yx*(va-vb-vc+vd) + vec2(vb,vc) - va));
}


void effect()
{
    vec2 randomtex = vec2(rand(love_PixelCoord )-0.5, rand(love_PixelCoord+100 )-0.5);
    vec2 randomnoise = 0.7*noised(0.02*love_PixelCoord+vec2(time*0.01,0) ).yz
     + 0.6*noised(0.04*love_PixelCoord+vec2(time*0.01,0) ).yz
     + 0.5*noised(0.08*love_PixelCoord+vec2(time*0.01,0) ).yz
     + 0.4*noised(0.16*love_PixelCoord+vec2(time*0.01,0) ).yz;
     randomnoise = randomnoise.yx*vec2(-1.0,1.0);
    vec2 randomdiffuse = vec2(rand(love_PixelCoord + offset)-0.5, rand(love_PixelCoord+100 + offset)-0.5);

    float p = Texel(g3, (love_PixelCoord)/love_ScreenSize.xy).a;
    float x1 = Texel(g3, (love_PixelCoord+vec2(-1.0,0.0))/love_ScreenSize.xy).a;
    float y1 = Texel(g3, (love_PixelCoord+vec2(0.0,-1.0))/love_ScreenSize.xy).a;
    float x2 = Texel(g3, (love_PixelCoord+vec2(1.0,0.0))/love_ScreenSize.xy).a;
    float y2 = Texel(g3, (love_PixelCoord+vec2(0.0,1.0))/love_ScreenSize.xy).a;
    vec2 n = - 0.5*vec2(x1-x2,y1-y2);
    float lap = p - 0.25*(x1+y1+x2+y2);
    float l = length(n) + 0.0001;
    //float amt = clamp(l,0.3,1);
    float amt = smoothstep(0.05,0.2,l);

    n = n*amt/l;

    float ranmt = 0.005*smoothstep(0.3,0.0,p);

    
    vec2 r = 0.02*n + ranmt*(1.0*randomdiffuse + 1.0*randomtex + 0.3*randomnoise);

    r = 5*r;

    vec4 c3 = Texel(g3, (love_PixelCoord + r)/love_ScreenSize.xy);
    c3.a = c3.a - 0.05*lap;
    //float l = length(love_PixelCoord-pos);
    //r = r*exp(-0.0001*l*l);
    love_Canvases[0] = Texel(g1, (love_PixelCoord + r)/love_ScreenSize.xy);
    love_Canvases[1] = Texel(g2, (love_PixelCoord + r)/love_ScreenSize.xy);
    love_Canvases[2] = c3;
}
