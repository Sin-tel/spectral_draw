require("spectrum")
require("d65")
require("reflectance")

pigment = {}

function pigment.init()
	wavelengths = {}
	for i = 1,11 do
		--wavelengths[i] = 400 + 35*(i-1) 
		wavelengths[i] = 480 + 25*(i-4) 
		--print(wavelengths[i] )
	end

	illuminant = {}
	for i,v in ipairs(wavelengths) do
		illuminant[i] = D65[(v-380)/2.5 + 2] / 100
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
		matching.x[i] = illuminant[i]*matching.x[i]/sumx
		matching.y[i] = illuminant[i]*matching.y[i]/sumy
		matching.z[i] = illuminant[i]*matching.z[i]/sumz

		--print(matching.x[i], matching.y[i], matching.z[i])
	end

	matching_vec3 = {}
	for i,v in ipairs(wavelengths) do
		matching_vec3[i] = {matching.x[i],matching.y[i],matching.z[i]}
	end

	compShader:send("matching",unpack(matching_vec3))
end


function RtoA(x)
	return ((1-x)^2)/(2*x)
end

function AtoR(x)
	return 1 + x - math.sqrt(x^2 + 2*x)
end