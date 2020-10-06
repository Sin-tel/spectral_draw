transform = {}
transform.s = 1.0
transform.x = 0
transform.y = 0
transform.r = 0

function transform.update()
	if mouseDown[3] then
		if love.keyboard.isDown('lshift') then
			local x1, y1 = pmouseX - 0.5*width, pmouseY - 0.5*height
			local x2, y2 = mouseX - 0.5*width, mouseY - 0.5*height

			local a1 = math.atan2(x1,y1)
			local a2 = math.atan2(x2,y2)


			transform.r = transform.r + a1-a2
			transform.r = (transform.r+math.pi)%(2*math.pi) - math.pi

			--if math.abs(transform.r) < 0.02 then
			if math.abs(math.sin(2*transform.r)) < 0.04 then
				transform.r = 0.5*math.pi*math.floor(0.5 + transform.r/(0.5*math.pi))
				--transform.r = 0
			end

			compShader:send("angle", transform.r)

		elseif love.keyboard.isDown('lctrl') then
			local s = math.log(initS)/math.log(2)
			s = s -0.01*(mouseY - mouseDragY)
			
			if s > 2 then
				s = 2
			end
			if s < -3 then
				s = -3
			end

			local frac = s - math.floor(s)
			frac = math.max(math.min(0.5+1.2*(frac-0.5),1),0)
			s = math.floor(s) + frac


			transform.s = 2^s
		else
			local dx = (mouseX - mouseDragX)/transform.s
			local dy = (mouseY - mouseDragY)/transform.s
			local a = transform.r
			transform.x = initX + dx*math.cos(a) + dy*math.sin(a)
			transform.y = initY - dx*math.sin(a) + dy*math.cos(a)
		end
	end
end

function invTransform(xx,yy)
	--[[
	love.graphics.translate(0.5*width, 0.5*height)
	love.graphics.scale(transform.s, transform.s)
	love.graphics.rotate(transform.r)
	love.graphics.translate(-0.5*width + transform.x, -0.5*height + transform.y)
	]]
	local x = xx - 0.5*width
	local y = yy - 0.5*height
	x = x / transform.s
	y = y / transform.s

	local a = transform.r
	x, y = x*math.cos(a) + y*math.sin(a), - x*math.sin(a) + y*math.cos(a)



	x = x + 0.5*width  - transform.x
	y = y + 0.5*height - transform.y
	return x,y
end