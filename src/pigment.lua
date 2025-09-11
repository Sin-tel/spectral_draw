local wavelengthToXyzTable = require("data/spectrum")
local D65 = require("data/d65")

local Pigment = {}

function Pigment.init(compShader)
	Pigment.wavelengths = {}
	for i = 1, 11 do
		--wavelengths[i] = 400 + 35*(i-1)
		Pigment.wavelengths[i] = 480 + 25 * (i - 4)
		--print(wavelengths[i] )
	end

	local illuminant = {}
	for i, v in ipairs(Pigment.wavelengths) do
		illuminant[i] = D65[(v - 380) / 2.5 + 2] / 100
	end

	local matching = {}
	matching.x = {}
	matching.y = {}
	matching.z = {}

	local sumx = 0
	local sumy = 0
	local sumz = 0
	for i, v in ipairs(Pigment.wavelengths) do
		local x = wavelengthToXyzTable[(v - 390) * 4 + 2]
		local y = wavelengthToXyzTable[(v - 390) * 4 + 3]
		local z = wavelengthToXyzTable[(v - 390) * 4 + 4]
		--print(x,y,z)

		matching.x[i] = x
		matching.y[i] = y
		matching.z[i] = z

		sumx = sumx + x
		sumy = sumy + y
		sumz = sumz + z
	end
	for i, v in ipairs(Pigment.wavelengths) do
		matching.x[i] = illuminant[i] * matching.x[i] / sumx
		matching.y[i] = illuminant[i] * matching.y[i] / sumy
		matching.z[i] = illuminant[i] * matching.z[i] / sumz

		--print(matching.x[i], matching.y[i], matching.z[i])
	end

	local matching_vec3 = {}
	for i, v in ipairs(Pigment.wavelengths) do
		matching_vec3[i] = { matching.x[i], matching.y[i], matching.z[i] }
	end

	compShader:send("matching", unpack(matching_vec3))
end

function Pigment.RtoA(x)
	return ((1 - x) ^ 2) / (2 * x)
end

function Pigment.AtoR(x)
	return 1 + x - math.sqrt(x ^ 2 + 2 * x)
end

function Pigment.read(t)
	local c = {}
	local floor = math.floor
	for i, v in ipairs(Pigment.wavelengths) do
		local index = (v - 360) / 10
		local a = index - floor(index)

		c[i] = ((1 - a) * t[floor(index)] + a * t[floor(index) + 1]) / 100
	end

	return c
end

return Pigment
