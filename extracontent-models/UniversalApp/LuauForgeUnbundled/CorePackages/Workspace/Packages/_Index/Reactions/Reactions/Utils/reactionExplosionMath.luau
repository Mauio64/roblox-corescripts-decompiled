local function clamp(p2, p3, p4)
	return (math.max(p3, (math.min(p4, p2))))
end

local function lerp(p2, p3, p4)
	return p2 + (p3 - p2) * p4
end

local function easeOutQuint(p2)
	return 1 - (1 - p2) ^ 5
end

local function easeOutQuad(p2)
	return 1 - (1 - p2) ^ 2
end

local function easeInQuad(p2)
	return p2 * p2
end

local function popScale(p2)
	if p2 <= 0 then
		return 0
	end

	if p2 < 0.15 then
		return 0 + 1.15 * (1 - (1 - p2 / 0.15) ^ 2)
	end

	if p2 < 0.35 then
		return 1.15 + -0.1499999999999999 * ((p2 - 0.15) / 0.19999999999999998)
	end

	return 1
end

local function fadeTransparency(p2)
	if p2 <= 0.55 then
		return 0
	end

	local v5 = (p2 - 0.55) / 0.44999999999999996
	return (math.max(0, (math.min(1, v5 * v5))))
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
	solveParticle = function(p2, data)
		local v5 = math.max(0, (math.min(1, p2)))

		local v6 = data.reach * (1 - (1 - v5) ^ 5)
		local v7 = 170 * v5 * v5
		local v8 = math.sin(data.angle) * v6
		local v9 = v8 >= 0 and 1.5 or 0.6
		local v10 = {
			x = math.cos(data.angle) * v6 * 1.4,
			y = v8 * v9 + v7,
			rotation = data.spin * v5,
			scale = 0,
			transparency = 0
		}
		local sizeScale = data.sizeScale
		local v11

		if v5 <= 0 then
			v11 = 0
		elseif v5 < 0.15 then
			v11 = 0 + 1.15 * (1 - (1 - v5 / 0.15) ^ 2)
		else
			v11 = not (v5 < 0.35) and 1 or 1.15 + -0.1499999999999999 * ((v5 - 0.15) / 0.19999999999999998)
		end

		v10.scale = sizeScale * v11
		local v12

		if v5 <= 0.55 then
			v12 = 0
		else
			local v13 = (v5 - 0.55) / 0.44999999999999996
			v12 = math.max(0, (math.min(1, v13 * v13)))
		end

		v10.transparency = v12
		return v10
	end
}
