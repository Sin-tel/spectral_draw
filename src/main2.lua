require("spectrum")
require("D65")
require("reflectance")
io.stdout:setvbuf("no")


width = 800
height = 600

love.window.setMode( width, height, {vsync = false} )
--love.window.setMode(width, height, { vsync = true, fullscreen = false, fullscreentype = "desktop", borderless = false, resizable = true } ) 

canvas = love.graphics.newCanvas(width, height, {format = "rgba32f"})


compShader = love.graphics.newShader("comp.glsl")

mouseX = 0
mouseY = 0



function love.load()
	
	math.randomseed(os.time())
	love.math.setRandomSeed(os.time())
	--math.randomseed(1)
	--love.graphics.setLineStyle("rough")

	wavelengths = {}
	for i = 1,11 do
		--wavelengths[i] = 400 + 35*(i-1) 
		wavelengths[i] = 480 + 25*(i-4) 
		print(wavelengths[i] )
	end
	
	matching = {}
	matching.x = {}
	matching.y = {}
	matching.z = {}

	sumx = 0
	sumy = 0
	sumz = 0
	for i,v in ipairs(wavelengths) do
		local x = wavelengthToXyzTable[(v-390)*4+2]
		local y = wavelengthToXyzTable[(v-390)*4+3]
		local z = wavelengthToXyzTable[(v-390)*4+4]
		--print(x,y,z)

		matching.x[i] = x
		matching.y[i] = y
		matching.z[i] = z

		sumx = sumx + x
		sumy = sumy + y
		sumz = sumz + z
	end
	for i,v in ipairs(wavelengths) do
		matching.x[i] = matching.x[i]/sumx
		matching.y[i] = matching.y[i]/sumy
		matching.z[i] = matching.z[i]/sumz

		--print(matching.x[i], matching.y[i], matching.z[i])
	end

	illuminant = {}
	for i,v in ipairs(wavelengths) do
		illuminant[i] = D65[(v-380)/2.5 + 2] / 100
	end

	--print()

	color2 = readRefl(colors.cobaltBlue)
	--color2 = {.12,.15,0.15,0.06,0.03,0.02,0.03,0.05,.05,.05,.05}
	for i,v in ipairs(color2) do
		print(v)
	end

	print(spectrumToRGB(color2))
	
end

function love.update(dt)
	mouseX,mouseY = love.mouse.getPosition()
end




function love.draw()
	love.graphics.setBackgroundColor(.5,.5,.5)
	--love.graphics.setBackgroundColor(0,0,0)
	for i,v in ipairs(wavelengths) do
		love.graphics.setColor(1, 0, 0)
		love.graphics.ellipse("line", 10+i*25, 200-matching.x[i]*300,3)

		love.graphics.setColor(0, 1, 0)
		love.graphics.ellipse("line", 10+i*25, 200-matching.y[i]*300,3)

		love.graphics.setColor(.1, 0.2, 1)
		love.graphics.ellipse("line", 10+i*25, 200-matching.z[i]*300,3)
	end

	--[[local color2 = {}
	for i=1,11 do
		local xx = (i/11)*2   - 2*mouseX/width
		color2[i] = 0.02 + 0.80*math.exp(  -mouseY*(xx^2)/50)*math.sqrt(1 - mouseY/height)
		--color2[i] = math.exp(  -mouseY*(xx^2)/50)*math.sqrt(1 - mouseY/height)

		--color2[i] = 1.0--mouseX/width
	end]]
	love.graphics.setColor(1, 1, 1)

	--[[local r,g,b = spectrumToRGB(c)
	love.graphics.print(r,10,10)
	love.graphics.print(g,10,20)
	love.graphics.print(b,10,30)

	for i,v in ipairs(c) do
		love.graphics.ellipse("line", 100+i*25, 200-v*100,3)
	end
	love.graphics.setColor(.25, .25, .25)
	love.graphics.line(125, 200, 375, 200)
	love.graphics.line(125, 100, 375, 100)
	love.graphics.setColor(spectrumToRGB(c))
	love.graphics.rectangle("fill", 20, 50, 50, 50)]]

	--local color1 = {.6,.8,.3,.2,.1,.05,.02,.02,0.02,0.02,0.02}
	--local color1 = {.03,.04,.05,.2,.3,.5,.6,.7,.8,.8,.8}
	--local color1 = {.8,.8,.5,.3,.15,.02,.02,.02,0.04,0.05,0.05}
	local color1 = readRefl(colors.titaniumWhite)

	--print(spectrumToRGB(color1))
	love.graphics.setColor(spectrumToRGB(color1))
	love.graphics.rectangle("fill", 50, 300, 50, 50)

	--local color2 = readRefl(colors.quinacridoneCrimson)
	--print(spectrumToRGB(color2))
	--local color2 = {.03,.04,.05,.2,.3,.5,.6,.7,.8,.8,.8}
	--local color2 = {.1,.1,.05,.03,.02,.05,.05,.1,.3,.7,.8}
	--local color2 = {.03,.03,.03,.03,.03,.03,.03,10,.03,.03,.03}
	love.graphics.setColor(spectrumToRGB(color2))
	love.graphics.rectangle("fill", 600, 300, 50, 50)

	

	for i = 0,500 do
		local c = {}
		local t = (i)/500
		--t = 1 - 1/(1+math.exp(12*(t-0.5)))
		t = t*t*(3-2*t)
		for j in ipairs(color1) do
			local c1 = RtoA(color1[j])
			local c2 = RtoA(color2[j])
			local mix =  ((1-t)*c1  + t*c2)--*0.5 + 0.5*RtoA(0.61)
			--mix = c2*((1-t)*30+1)
			c[j] = AtoR(mix)

			--[[local c1 = (color1[j])
			local c2 = (color2[j])
			local mix =  (1-t)*c1  + t*c2
			c[j] = (mix)]]
		end
		love.graphics.setColor(spectrumToRGB(c))
		love.graphics.rectangle("fill", 100+i*1, 300, 1, 50)

	end

	for i,v in ipairs(wavelengths) do
		local t = mouseX/width
		local c1 = RtoA(color1[i])
		local c2 = RtoA(color2[i])
		local mix =  ((1-t)*c1  + t*c2)--*0.5 + 0.5*RtoA(0.61)
		--mix = c2*((1-t)*30+1)
		--c[i] = AtoR(mix)
		love.graphics.setColor(1, 1, 1)
		love.graphics.ellipse("line", 10+i*25, 200-AtoR(mix)*100,3)
	end
end

function RtoA(x)
	return ((1-x)^2)/(2*x)
end

function AtoR(x)
	return 1 + x - math.sqrt(x^2 + 2*x)
end

function love.keypressed( key, isrepeat )
	if key == 'escape' then
		love.event.quit()
    end
end

function love.mousepressed(x, y, button)

end

function spectrumToRGB(s)
	assert(#s == 11)
	local x = 0
	local y = 0
	local z = 0

	for i,v in ipairs(s) do
		local l = v*illuminant[i]
		x = x + matching.x[i]*l
		y = y + matching.y[i]*l
		z = z + matching.z[i]*l
	end

	local r =  3.2404542*x -1.5371385*y -0.4985314*z
	local g = -0.9692660*x +1.8760108*y +0.0415560*z
	local b =  0.0556434*x -0.2040259*y +1.0572252*z

	r = clamp(r)
	g = clamp(g)
	b = clamp(b)

	--TODO better rgb transfer
	r = r^(1/2.2)
	g = g^(1/2.2)
	b = b^(1/2.2)

	return r,g,b
end


function clamp(x)
	if love.keyboard.isDown("c") then
		local t = math.min(math.max((0.92*x + 0.05), 0), 1)
		return t*t*(3.0 - 2.0*t)
	end

	return math.min(math.max(x, 0), 1)
end