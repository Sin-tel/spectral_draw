--[[
Source of these:
Developing a spectral and colorimetric database of artist paint materials
by: Yoshio Okumura
https://scholarworks.rit.edu/theses/4892/

360-760 in 10nm incr
GOLDEN_matte_varnish_all_sce.txt

]]

function readRefl(t)
	local c = {}
	local floor = math.floor
	for i,v in ipairs(wavelengths) do
		local index = (v-360)/10
		local a = index - floor(index)


		c[i] = ((1-a)*t[floor(index)] + a*t[floor(index)+1])/100
	end

	return c
end

colors = {}

colors.titaniumWhite = {
	0.88,0.86,0.89,3.82,21.78,54.36,
	77.73,85.41,86.90,87.33,87.56,87.69,
	87.91,88.19,88.31,88.38,88.54,88.68,
	88.75,88.83,88.90,88.96,88.93,88.89,
	88.97,88.97,89.00,88.90,89.03,88.93,
	88.69,88.41,88.35,88.26,88.05,87.77,
	87.39,86.81,86.34,85.86
}

colors.carbonBlack = {
	0.71,0.70,0.68,0.78,1.01,1.10,
	1.07,1.07,1.07,1.04,1.03,1.04,
	1.01,0.99,1.00,0.98,0.94,0.96,
	0.96,0.94,0.96,0.96,0.92,0.92,
	0.93,0.94,0.94,0.93,0.91,0.92,
	0.94,0.92,0.91,0.91,0.93,0.92,
	0.94,0.92,0.93,0.89
}

colors.cobaltBlue = {
	0.34,0.32,0.51,3.75,13.29,22.21,
	28.32,30.88,30.99,29.43,27.82,24.30,
	20.82,22.53,18.49,10.63,5.01,2.30,
	1.20,0.91,0.79,0.63,0.58,0.57,
	0.66,0.75,0.76,0.84,1.23,2.51,
	5.71,12.47,23.51,38.16,52.63,62.44,
	67.33,69.58,70.78,71.45
}

colors.chromiumOxideGreen = {
	0.37,0.35,0.40,1.93,7.39,10.74,
	8.31,5.41,3.71,2.96,2.77,2.91,
	3.46,4.61,6.15,8.74,13.74,18.53,
	18.84,15.49,11.48,8.39,6.46,5.57,
	5.35,5.61,6.10,6.84,7.80,9.10,
	10.75,12.62,14.43,16.15,17.98,19.93,
	22.72,26.61,31.27,36.48
}

colors.quinacridoneMagenta = {
0.37,0.39,0.67,4.21,13.04,19.17,
20.41,19.43,17.32,14.97,12.82,10.89,
8.92,7.21,6.04,5.03,3.90,3.09,
2.90,3.09,3.14,3.58,5.71,10.82,
19.20,29.85,40.64,49.58,56.36,60.89,
63.96,66.27,68.23,69.73,70.82,71.69,
72.22,72.51,72.70,72.78
}

colors.diarylideYellow = {
	1.23,1.19,1.22,1.60,2.35,2.69,
	2.68,2.59,2.47,2.41,2.37,2.29,
	2.18,2.20,2.41,3.23,6.92,17.67,
	35.20,51.95,64.45,73.10,77.60,79.63,
	80.64,81.37,82.03,82.62,83.28,83.63,
	83.76,83.89,83.94,84.05,84.03,83.97,
	83.61,83.35,83.03,82.71
}

colors.phthaloBlue = {
0.82,0.88,0.90,1.46,3.04,4.19,
4.41,4.90,6.47,7.51,7.12,6.08,
4.47,2.93,1.75,1.08,0.88,0.86,
0.92,1.03,1.11,1.15,1.18,1.20,
1.25,1.26,1.30,1.30,1.31,1.27,
1.25,1.21,1.21,1.23,1.28,1.41,
1.58,1.81,2.24,3.31
}

colors.yellowOpaque = {
0.50,0.46,0.47,0.72,1.25,1.56,
1.60,1.61,1.54,1.44,1.46,1.52,
1.61,2.47,7.40,21.00,40.46,57.96,
69.35,75.16,77.86,79.38,80.47,81.39,
82.14,82.66,83.00,83.42,83.81,84.00,
83.87,83.85,83.74,83.68,83.55,83.47,
83.01,82.67,82.31,81.86
}


colors.redOxide = {
0.23,0.24,0.26,0.40,0.74,0.92,
0.97,0.99,0.98,0.99,1.02,1.03,
1.06,1.11,1.14,1.20,1.28,1.43,
1.68,2.21,3.36,5.61,9.14,13.45,
17.48,20.32,22.11,23.19,24.03,24.97,
25.96,27.23,28.77,30.51,32.33,34.10,
35.63,36.66,37.03,36.72
}

colors.phthaloGreen = {
0.59,0.61,0.59,0.73,0.98,1.15,
1.23,1.32,1.43,1.66,2.20,3.14,
4.36,5.33,4.86,3.49,2.23,1.37,
0.87,0.61,0.53,0.55,0.61,0.70,
0.76,0.81,0.85,0.89,0.88,0.95,
1.01,1.06,1.10,1.11,1.10,1.07,
1.06,1.13,1.28,1.40
}

colors.pyrroleRed = {
0.61,0.60,0.59,0.66,0.63,0.65,
0.63,0.67,0.70,0.72,0.78,0.79,
0.78,0.83,0.84,0.87,0.84,0.81,
0.87,1.05,1.24,1.46,2.36,9.36,
25.34,41.31,54.39,64.70,71.68,75.35,
77.28,78.68,79.80,80.66,81.33,81.89,
82.00,82.03,82.10,82.07
}

colors.yellowOchre = {
0.49,0.48,0.45,0.73,1.39,1.90,
2.25,2.75,3.44,3.96,4.15,4.27,
4.51,5.03,5.93,7.36,9.44,12.38,
16.25,20.59,24.97,29.09,32.21,34.06,
34.84,34.81,34.45,34.07,33.74,33.64,
33.73,34.18,34.89,35.93,37.10,38.46,
39.75,40.94,41.82,42.14
}

colors.ultramarineBlue = {
0.40,0.39,0.46,1.25,3.03,4.56,
5.88,7.39,8.55,8.51,6.75,4.10,
2.14,1.21,0.80,0.60,0.47,0.41,
0.38,0.37,0.36,0.35,0.35,0.34,
0.33,0.34,0.35,0.38,0.38,0.43,
0.47,0.52,0.60,0.75,0.95,1.25,
1.71,2.25,2.83,3.35
}

colors.sintelPurple = {

	2,3,5,9,10,12,
	13,14,15,12,10,7,
	5,3,3,2,2,2,
	3,3,4,4,4,5,
	5,5,5,6,6,7,
	8,9,10,12,13,14,
	15,16,17,18
}
--[[

19.20,29.85,40.64,49.58,56.36,60.89,
63.96,66.27,68.23,69.73,70.82,71.69,
72.22,72.51,72.70,72.78

colors.dioxazinePurple = {
0.91,0.92,1.01,2.93,8.15,12.32,
14.29,15.43,15.64,14.75,13.07,10.97,
8.58,6.25,4.64,3.64,2.91,2.50,
2.36,2.34,2.29,2.33,2.62,3.11,
3.59,3.51,3.14,3.13,3.86,5.58,
8.70,13.36,19.49,26.51,33.65,40.12,
45.64,50.10,53.56,56.09
}]]

colors.greenGold = {
1.09,1.12,1.14,1.26,1.46,1.53,
1.54,1.54,1.54,1.54,1.72,2.16,
3.57,6.10,8.64,10.93,13.09,15.02,
16.65,17.91,18.45,18.00,16.77,15.04,
12.83,11.01,10.08,9.68,9.47,9.31,
9.55,10.16,11.06,12.02,12.70,12.66,
12.01,11.60,12.05,12.88
}

colors.ceruleanBlue = {
0.75,0.74,1.11,5.14,13.31,18.36,
20.67,22.06,24.13,27.42,30.53,31.65,
30.47,31.07,29.13,22.21,14.67,9.00,
5.37,3.66,3.08,2.57,2.17,2.05,
2.14,2.35,2.35,2.39,2.91,4.85,
9.91,19.77,33.30,46.43,56.13,61.99,
65.20,66.91,67.89,68.41
}

colors.titaniumBuff = {
0.43,0.34,0.42,3.32,13.62,24.79,
31.28,35.63,39.18,42.43,45.16,47.17,
48.82,50.22,51.54,53.09,54.81,56.40,
57.90,59.41,60.89,62.46,63.76,64.94,
66.00,66.92,67.74,68.43,69.20,69.71,
70.09,70.34,70.72,71.13,71.39,71.62,
71.65,71.55,71.44,71.25
}

colors.quinacridoneCrimson = {
1.18,1.20,1.20,1.48,1.78,1.78,
1.72,1.66,1.59,1.55,1.54,1.49,
1.44,1.39,1.34,1.29,1.28,1.28,
1.27,1.26,1.29,1.36,1.56,2.24,
3.80,5.99,8.31,10.12,11.27,12.02,
12.58,12.97,13.17,13.73,15.00,16.92,
19.23,21.73,24.40,27.16
}

colors.rawUmber = {
0.54,0.57,0.53,0.64,0.86,1.00,
1.04,1.12,1.18,1.18,1.20,1.22,
1.24,1.28,1.34,1.41,1.51,1.61,
1.71,1.81,1.93,2.04,2.12,2.16,
2.23,2.25,2.26,2.31,2.29,2.30,
2.28,2.30,2.31,2.33,2.35,2.36,
2.35,2.38,2.37,2.34
}

colors.burntSienna = {
0.29,0.30,0.31,0.38,0.52,0.64,
0.66,0.68,0.72,0.74,0.77,0.80,
0.83,0.90,0.95,1.02,1.11,1.25,
1.49,1.89,2.57,3.60,4.87,6.33,
7.87,9.32,10.69,11.93,13.07,14.14,
15.15,16.25,17.41,18.58,19.64,20.63,
21.47,22.00,22.30,22.22
}

colors.burntUmber = {
0.89,0.86,0.88,1.01,1.13,1.18,
1.20,1.22,1.23,1.25,1.27,1.31,
1.32,1.35,1.38,1.42,1.47,1.57,
1.65,1.78,1.97,2.16,2.39,2.55,
2.75,2.92,3.08,3.19,3.32,3.47,
3.58,3.70,3.79,3.96,4.07,4.16,
4.29,4.39,4.47,4.48
}

colors.jenkinsGreen = {
0.48,0.42,0.52,0.65,0.91,1.00,
1.04,1.08,1.09,1.11,1.25,1.48,
1.80,1.91,1.84,1.79,1.71,1.65,
1.58,1.49,1.40,1.30,1.20,1.08,
1.05,0.99,0.96,0.93,0.93,0.95,
1.01,1.05,1.10,1.12,1.12,1.08,
1.07,1.11,1.20,1.26
}

--80%
colors.anthraquinoneBlue = {
0.78,0.80,0.92,3.29,10.54,17.69,
20.64,20.77,19.50,17.66,15.47,13.40,
11.56,10.01,8.60,7.30,6.22,5.27,
4.46,3.86,3.43,3.06,2.78,2.62,
2.52,2.43,2.37,2.37,2.39,2.48,
2.55,2.64,2.75,2.92,3.19,3.51,
3.88,4.15,4.24,4.09
}

colors.permanentGreenLight = {
0.32,0.32,0.31,0.50,0.86,1.03,
1.09,1.15,1.25,1.37,1.81,3.83,
10.29,19.62,26.70,28.84,26.08,21.30,
16.15,11.55,8.00,5.47,3.67,2.47,
1.76,1.41,1.28,1.24,1.20,1.19,
1.26,1.36,1.50,1.63,1.73,1.72,
1.65,1.66,1.87,2.19
}

--0.80
colors.naptholRedMedium = {
1.72,1.74,1.92,3.65,6.16,7.14,
7.11,7.01,6.75,6.22,5.64,5.07,
4.60,4.24,3.98,3.77,3.62,3.55,
3.50,3.45,3.58,4.38,7.05,12.96,
22.40,33.76,45.29,55.52,63.69,69.48,
73.16,75.69,77.37,78.58,79.37,80.13,
80.51,80.72,80.90,81.02
}

colors.rawSienna = {
0.44,0.45,0.45,0.74,1.30,1.69,
1.94,2.27,2.70,3.00,3.11,3.18,
3.33,3.71,4.27,5.15,6.46,8.35,
10.94,14.09,17.41,20.45,22.66,24.17,
24.89,25.05,24.91,24.72,24.60,24.63,
24.77,25.21,25.92,26.80,27.78,28.88,
29.98,30.96,31.75,32.05
}

colors.paynesGray = {
0.34,0.36,0.35,0.50,0.73,0.87,
0.89,0.89,0.88,0.85,0.83,0.79,
0.70,0.65,0.57,0.51,0.44,0.40,
0.35,0.33,0.32,0.31,0.31,0.32,
0.31,0.29,0.32,0.33,0.35,0.35,
0.37,0.38,0.44,0.49,0.56,0.62,
0.68,0.71,0.76,0.75
}

--0.80
colors.turquois = {
1.27,1.28,1.30,2.07,4.46,6.39,
7.32,8.24,9.45,11.38,14.80,19.79,
24.47,26.35,24.14,19.94,15.52,11.65,
8.55,6.27,4.70,3.79,3.31,2.97,
2.69,2.52,2.46,2.47,2.46,2.52,
2.59,2.66,2.74,2.77,2.79,2.81,
2.83,2.97,3.30,3.79
}

colors.hansaYellowMedium = {
0.94,0.94,0.94,1.00,1.07,1.12,
1.14,1.20,1.20,1.22,1.31,1.39,
1.65,2.63,5.79,13.63,26.54,40.78,
52.10,59.39,63.92,67.02,69.39,71.25,
72.97,74.26,75.32,76.28,77.27,77.90,
78.15,78.39,78.45,78.54,78.64,78.70,
78.57,78.49,78.41,78.13
}