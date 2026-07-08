local function clamp(n1: number, n2: number, n3: number) -- line: 52
	return (math.max(n2, (math.min(n3, n1))))
end
local function lerp(n4: number, n5: number, n6: number) -- line: 56
	return n4 + (n5 - n4) * n6
end
local function easeOutQuint(n7: number) -- line: 60
	return 1 - (1 - n7) ^ 5
end
local function easeOutQuad(n8: number) -- line: 64
	return 1 - (1 - n8) ^ 2
end
local function easeInQuad(n9: number) -- line: 68
	return n9 * n9
end
local function popScale(n10: number) -- line: 73
	if n10 <= 0 then
		return 0
	end

	if n10 < 0.15 then
		return (1 - (1 - n10 / 0.15) ^ 2) * 1.15 + 0
	end

	if n10 < 0.35 then
		return (n10 - 0.15) / 0.19999999999999998 * -0.1499999999999999 + 1.15
	end

	return 1
end
local function fadeTransparency(n11: number) -- line: 85
	if n11 <= 0.55 then
		return 0
	end

	local v19 = (n11 - 0.55) / 0.44999999999999996

	return (math.max(0, (math.min(1, v19 * v19))))
end

return {
	DURATION = 0.8,
	MAX_REACH = 110,
	REACH_MIN_FACTOR = 0.7,
	REACH_RANGE = 0.3,
	GRAVITY = 170,
	X_STRETCH = 1.4,
	Y_SQUASH_UP = 0.6,
	Y_STRETCH_DOWN = 1.5,
	ANGLE_JITTER = 0.5,
	SPIN_MIN = 90,
	SPIN_RANGE = 110,
	SIZE_MIN = 0.85,
	SIZE_RANGE = 0.3,
	MIN_PARTICLES = 12,
	MAX_PARTICLES = 16,
	FADE_START = 0.55,
	OVERSHOOT = 1.15,
	solveParticle = function(n12: number, t1: {[any]: any}) -- line: 92
		local v22 = math.max(0, (math.min(1, n12)))
		local v23 = t1.reach * (1 - (1 - v22) ^ 5)
		local v24 = v22 * 170 * v22
		local v25 = math.sin(t1.angle) * v23
		local v26 = not (v25 >= 0) and 0.6 or 1.5
		local t2 = {
			x = math.cos(t1.angle) * v23 * 1.4,
			y = v25 * v26 + v24,
			rotation = t1.spin * v22,
			scale = t1.sizeScale * if not (v22 <= 0) then if not (v22 < 0.15) then not (v22 < 0.35) and 1 or (v22 - 0.15) / 0.19999999999999998 * -0.1499999999999999 + 1.15 else (1 - (1 - v22 / 0.15) ^ 2) * 1.15 + 0 else 0
		}
		local n13

		if v22 <= 0.55 then
			n13 = 0
		else
			local v29 = (v22 - 0.55) / 0.44999999999999996

			n13 = math.max(0, (math.min(1, v29 * v29)))
		end

		t2.transparency = n13

		return t2
	end
}
