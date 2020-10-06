require("tablet")
require("pigment")
require("transform")
require("zlib")

io.stdout:setvbuf("no")


w_canvas = 1754
h_canvas = 1240

width = 800
height = 600

love.window.setMode( width, height, {vsync = true, resizable = true} )
--love.window.setMode(width, height, { vsync = true, fullscreen = false, fullscreentype = "desktop", borderless = false, resizable = true } ) 

tex_format = "rgba16f"

canvas_1 = love.graphics.newCanvas(w_canvas, h_canvas, {format = tex_format})
canvas_2 = love.graphics.newCanvas(w_canvas, h_canvas, {format = tex_format})
canvas_3 = love.graphics.newCanvas(w_canvas, h_canvas, {format = tex_format})

canvas_1b = love.graphics.newCanvas(w_canvas, h_canvas, {format = tex_format})
canvas_2b = love.graphics.newCanvas(w_canvas, h_canvas, {format = tex_format})
canvas_3b = love.graphics.newCanvas(w_canvas, h_canvas, {format = tex_format})

canvas_final = love.graphics.newCanvas(w_canvas, h_canvas)


compShader = love.graphics.newShader("comp.glsl")
drawShader = love.graphics.newShader("mdraw.glsl")
diffuseShader = love.graphics.newShader("diffuse.glsl")
copyShader = love.graphics.newShader("copy.glsl")
moveShader = love.graphics.newShader("move.glsl")
outlineShader = love.graphics.newShader("outline.glsl")


mouseX = 0
mouseY = 0

alpha = 0.5

pmouseX,pmouseY = 0,0
time = 0

angle = 0
ax,ay = 0,0

mouseDown = {}




function love.load()
	
	math.randomseed(os.time())
	love.math.setRandomSeed(os.time())
	--math.randomseed(1)
	--love.graphics.setLineStyle("rough")

	love.mouse.setVisible( false )
	hourglass = love.mouse.getSystemCursor("wait")
	--cursor = love.mouse.newCursor("cursor2.png", 30, 30)
	--love.mouse.setCursor(cursor)

	brush = love.graphics.newImage("brush9.png")	

	Tablet.init()

	--[[canvas_1:setFilter("nearest", "nearest")
	canvas_2:setFilter("nearest", "nearest")
	canvas_3:setFilter("nearest", "nearest")
	canvas_1b:setFilter("nearest", "nearest")
	canvas_2b:setFilter("nearest", "nearest")
	canvas_3b:setFilter("nearest", "nearest")]]


	canvas_final:setFilter("linear", "nearest")


	transform.x = 0.5*(width  - w_canvas)
	transform.y = 0.5*(height - h_canvas)


	pigment.init()
	
	col = readRefl(colors.greenGold)

	local l = 0.5
	local bg = {l, l, l, l, l, l, l, l, l, l, l}
	--local bg = readRefl(colors.titaniumWhite)
	local th = 0.001

	love.graphics.setCanvas(canvas_1)
	love.graphics.clear(th*RtoA(bg[1]),th*RtoA(bg[2]),th*RtoA(bg[3]),th*RtoA(bg[4]))
	love.graphics.setCanvas(canvas_2)
	love.graphics.clear(th*RtoA(bg[5]),th*RtoA(bg[6]),th*RtoA(bg[7]),th*RtoA(bg[8]))
	love.graphics.setCanvas(canvas_3)
	love.graphics.clear(th*RtoA(bg[9]),th*RtoA(bg[10]),th*RtoA(bg[11]), th)
	love.graphics.setCanvas(canvas_1b)
	love.graphics.clear(th*RtoA(bg[1]),th*RtoA(bg[2]),th*RtoA(bg[3]),th*RtoA(bg[4]))
	love.graphics.setCanvas(canvas_2b)
	love.graphics.clear(th*RtoA(bg[5]),th*RtoA(bg[6]),th*RtoA(bg[7]),th*RtoA(bg[8]))
	love.graphics.setCanvas(canvas_3b)
	love.graphics.clear(th*RtoA(bg[9]),th*RtoA(bg[10]),th*RtoA(bg[11]), th)
	love.graphics.setCanvas()

	drawShader:send("g1",canvas_1)
	drawShader:send("g2",canvas_2)
	drawShader:send("g3",canvas_3)

	moveShader:send("g1",canvas_1)
	moveShader:send("g2",canvas_2)
	moveShader:send("g3",canvas_3)

	diffuseShader:send("g1",canvas_1)
	diffuseShader:send("g2",canvas_2)
	diffuseShader:send("g3",canvas_3)


	copyShader:send("g1",canvas_1b)
	copyShader:send("g2",canvas_2b)
	copyShader:send("g3",canvas_3b)
	
	compShader:send("g1",canvas_1)
	compShader:send("g2",canvas_2)
	compShader:send("g3",canvas_3)
end

function love.update(dt)

	pmouseX,pmouseY = mouseX,mouseY
	Tablet.update()
	--mouseX,mouseY = love.mouse.getPosition()
	local mvx2, mvy2 = mouseX - pmouseX, mouseY - pmouseY

	local x1,y1 = invTransform(pmouseX, pmouseY)
	local x2,y2 = invTransform(mouseX, mouseY)
	mvx, mvy = x2 - x1, y2 - y1

	time = time + dt


	if mvx2 ~= 0 or mvy2 ~= 0 then

		local l = math.sqrt(mvx2^2 + mvy2^2)/5
		if l < 1 then
			l = 1
		end
		ax = math.cos(angle)
		ay = math.sin(angle)
		local s = (ax*mvx2 + ay*mvy2)
		if s > 0 then
			s = 1
		else
			s = -1
		end
		angle = angle + 0.1*(ax*mvy2 - ay*mvx2)*s/l
	end
	if rot and tabletInput then
		angle = rot
	end

	transform.update()
end


function love.draw()
	love.graphics.setColor(1, 1, 1)
	love.graphics.setCanvas( canvas_1b, canvas_2b, canvas_3b)
	love.graphics.setBlendMode("replace","premultiplied")
	
	if mouseDown[1] and not love.keyboard.isDown('lctrl') then
		local s = 1.0--0.05 + 1.2*pres*pres

		if not love.keyboard.isDown('lshift') then

			local div = math.floor(math.sqrt(mvx^2 + mvy^2)/(15*s)) + 1
			for i = 1, div do
				love.graphics.setCanvas( canvas_1b, canvas_2b, canvas_3b)
				love.graphics.setShader(drawShader)
				drawShader:send("spectrum",unpack(col))

				local speed = math.sqrt(mvx^2 + mvy^2)
				if first then
					speed = 2
				end
				drawShader:send("alpha",alpha*speed/(15*div))
				drawShader:send("pres",pres)
				local t = i/div
				

				love.graphics.push()

				local mx, my = invTransform(pmouseX, pmouseY)
				mx = mx + t*mvx
				my = my + t*mvy
				love.graphics.translate(mx, my)
				love.graphics.rotate(angle - transform.r + love.math.randomNormal(.1))
				love.graphics.scale(s, s)
				love.graphics.translate(-30, -30)
				

				love.graphics.draw(brush, 0,0)

				love.graphics.setCanvas( canvas_1, canvas_2, canvas_3)
				love.graphics.setShader(copyShader)

				love.graphics.draw(brush, 0,0)

				love.graphics.pop()
				first = false
			end
		end
		--else

			
			local div = math.floor(math.sqrt(mvx^2 + mvy^2)/(5*s)) + 1
			for i = 1, div do
				love.graphics.setCanvas( canvas_1b, canvas_2b, canvas_3b)
				love.graphics.setShader(moveShader)
				moveShader:send("vel",{mvx/div,mvy/div})
				moveShader:send("pres",pres)
				local t = i/div

				love.graphics.push()
				local mx, my = invTransform(pmouseX, pmouseY)
				mx = mx + t*mvx
				my = my + t*mvy
				love.graphics.translate(mx, my)
				love.graphics.rotate(angle - transform.r + love.math.randomNormal(.2))
				love.graphics.scale(s, s)
				love.graphics.translate(-30, -30)

				love.graphics.draw(brush, 0,0)

				love.graphics.setCanvas( canvas_1, canvas_2, canvas_3)
				love.graphics.setShader(copyShader)
				love.graphics.draw(brush, 0,0)

				love.graphics.pop()
			end	
		--end
	
	end

	if love.keyboard.isDown("space") then
		love.graphics.setCanvas( canvas_1b, canvas_2b, canvas_3b)
		diffuseShader:send("offset",{math.random(),math.random()})
		--diffuseShader:send("time",time)
		--diffuseShader:send("pos",{mouseX,mouseY})
		love.graphics.setShader(diffuseShader)
		love.graphics.rectangle("fill", 0, 0, w_canvas, h_canvas)
	
		love.graphics.setCanvas( canvas_1, canvas_2, canvas_3)
		love.graphics.setShader(copyShader)
		love.graphics.rectangle("fill", 0, 0, w_canvas, h_canvas)
	end

	--final comp to rgb TODO: update only brush part
	love.graphics.setCanvas(canvas_final)
	love.graphics.setShader(compShader)
	love.graphics.rectangle("fill", 0, 0, w_canvas, h_canvas)

	-- draw to screen
	love.graphics.setCanvas()
	love.graphics.clear(.5,.5,.5,1)
	love.graphics.setShader()
	love.graphics.push()
	

	love.graphics.translate(0.5*width, 0.5*height)
	love.graphics.scale(transform.s, transform.s)
	love.graphics.rotate(transform.r)
	love.graphics.translate(-0.5*width + transform.x, -0.5*height + transform.y)
	
	love.graphics.setColor(0.4, 0.4, 0.4)
	love.graphics.rectangle("fill", 5*math.sin(transform.r), 5*math.cos(transform.r), w_canvas, h_canvas)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(canvas_final, 0, 0)

	love.graphics.pop()

	-- draw mouse
	love.graphics.setShader(outlineShader)

	love.graphics.setBlendMode("alpha")
	local s = 0.7

	love.graphics.push()
	love.graphics.translate((mouseX), (mouseY ))
	love.graphics.rotate(angle)
	
	love.graphics.scale(s*0.7, s)
	love.graphics.translate(-30, -30)

	love.graphics.draw(brush, 0,0)
	love.graphics.pop()
	
end

function love.keypressed( key, isrepeat )
	if key == 'escape' then
		love.event.quit()
	elseif key == 'q' then
		col = readRefl(colors.cobaltBlue)
	elseif key == 'w' then
		col = readRefl(colors.titaniumWhite)
	elseif key == 'e' then
		col = readRefl(colors.pyrroleRed)
	elseif key == 'r' then
		col = readRefl(colors.yellowOchre)
	elseif key == 't' then
		col = readRefl(colors.rawUmber)
	elseif key == 'y' then
		col = readRefl(colors.burntSienna)
	elseif key == 'u' then
		col = readRefl(colors.carbonBlack)
	elseif key == 'i' then
		col = readRefl(colors.chromiumOxideGreen)
    elseif key == 'a' then
		alpha = alpha * 2;
		if alpha > 1 then
			alpha = 1
		end
		print(alpha)
	elseif key == 'z' then
		alpha = alpha * 0.5;
		if alpha < 0.015625 then
			alpha = 0.015625
		end
		print(alpha)
	elseif key == 'c' then
		transform.r = 0
	elseif key == 'v' then
		transform.s = 1.0
		transform.x = 0.5*(width  - w_canvas)
		transform.y = 0.5*(height - h_canvas)
		transform.r = 0
	elseif key == 's' then
		love.mouse.setVisible( true )
		love.mouse.setCursor(hourglass)

		data1 = canvas_1:newImageData()
		data2 = canvas_2:newImageData()
		data3 = canvas_3:newImageData()

		local s1 = data1:getString()
		local s2 = data2:getString()
		local s3 = data3:getString()

		print("compressing...")
		s1 = compress(s1)
		s2 = compress(s2)
		s3 = compress(s3)

		love.filesystem.write( "s1", s1 )
		love.filesystem.write( "s2", s2 )
		love.filesystem.write( "s3", s3 )

		print("saved")
		love.mouse.setVisible( false )
	elseif key == 'l' then
		love.mouse.setVisible( true )
		love.mouse.setCursor(hourglass)

		local s1 = love.filesystem.read( "s1" )
		local s2 = love.filesystem.read( "s2" )
		local s3 = love.filesystem.read( "s3" )

		print("decompressing...")
		s1 = uncompress(s1, 8*w_canvas*h_canvas)
		s2 = uncompress(s2, 8*w_canvas*h_canvas)
		s3 = uncompress(s3, 8*w_canvas*h_canvas)

		local image1 = love.graphics.newImage( love.image.newImageData( w_canvas, h_canvas, tex_format, s1 ) )
		local image2 = love.graphics.newImage( love.image.newImageData( w_canvas, h_canvas, tex_format, s2 ) )
		local image3 = love.graphics.newImage( love.image.newImageData( w_canvas, h_canvas, tex_format, s3 ) )

		copyShader:send("g1",image1)
		copyShader:send("g2",image2)
		copyShader:send("g3",image3)

		love.graphics.setBlendMode("replace","premultiplied")
		love.graphics.setCanvas( canvas_1b, canvas_2b, canvas_3b)
		love.graphics.setShader(copyShader)
		love.graphics.rectangle("fill", 0, 0, w_canvas, h_canvas)

		love.graphics.setCanvas( canvas_1, canvas_2, canvas_3)
		love.graphics.rectangle("fill", 0, 0, w_canvas, h_canvas)

		love.graphics.setCanvas()
		copyShader:send("g1",canvas_1b)
		copyShader:send("g2",canvas_2b)
		copyShader:send("g3",canvas_3b)

		print("load")
		love.mouse.setVisible( false )
    end
end

function love.mousepressed(x, y, button)
	if not tabletInput then
		pres = 0.5
		mousepressed(button)
	end
end

function love.mousereleased(x, y, button)
	if not tabletInput then
		pres = 0
		mousereleased(button)
	end
end

function mousepressed(button)
	mouseDown[button] = true

	if button == 3 then
		mouseDragX = mouseX
		mouseDragY = mouseY

		initR = transform.r
		initS = transform.s
		initX = transform.x
		initY = transform.y
	end

	first = true
	if love.keyboard.isDown('lctrl') and button == 1 then
		local x,y = invTransform(mouseX, mouseY)
		local data1 = canvas_1:newImageData()
		local data2 = canvas_2:newImageData()
		local data3 = canvas_3:newImageData()

		local th = 0
		local c = {}
		c[1], c[2], c[3], c[4] = data1:getPixel(x, y);
		c[5], c[6], c[7], c[8] = data2:getPixel(x, y);
		c[9], c[10], c[11], th = data3:getPixel(x, y);

		print(c[1], c[2], c[3])
		for i,v in ipairs(c) do
			col[i] = AtoR(v/th)
		end
	end
end

function mousereleased(button)
	mouseDown[button] = false

end


function love.quit()
	Tablet.close()
end



function love.resize(w, h)
	width = w
	height = h
end