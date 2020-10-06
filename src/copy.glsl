uniform Image g1;
uniform Image g2;
uniform Image g3;

void effect()
{
    love_Canvases[0] = Texel(g1, (love_PixelCoord)/love_ScreenSize.xy);
    love_Canvases[1] = Texel(g2, (love_PixelCoord)/love_ScreenSize.xy);
    love_Canvases[2] = Texel(g3, (love_PixelCoord)/love_ScreenSize.xy);
}
