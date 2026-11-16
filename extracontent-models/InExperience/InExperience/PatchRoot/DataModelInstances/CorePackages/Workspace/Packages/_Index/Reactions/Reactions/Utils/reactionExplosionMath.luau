local function clamp(p: number, p2: number, p3: number) -- 2 equivalent calls inferred from this helper
	return (math.max(p2, (math.min(p3, p))))
end

local function lerp(p: number, p2: number, p3: number)
	return p + (p2 - p) * p3
end

local function easeOutQuint(p: number) -- 1 equivalent call inferred from this helper
	return 1 - (1 - p) ^ 5
end

local function easeOutQuad(p: number) -- 1 equivalent call inferred from this helper
	return 1 - (1 - p) ^ 2
end

local function easeInQuad(p: number) -- 1 equivalent call inferred from this helper
	return p * p
end

local function popScale(p: number) -- 1 equivalent call inferred from this helper
	if p <= 0 then
		return 0
	end

	if p < 0.15 then
		return easeOutQuad(p / 0.15) * 1.15 + 0 -- inferred equivalent call
	end

	if p < 0.35 then
		return (p - 0.15) / 0.19999999999999998 * -0.1499999999999999 + 1.15
	end

	return 1
end

local function fadeTransparency(p: number) -- 1 equivalent call inferred from this helper
	if p <= 0.55 then
		return 0
	end

	return clamp(easeInQuad((p - 0.55) / 0.44999999999999996), 0, 1) -- inferred equivalent call
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
	solveParticle = function(p: number, data)
		local v = clamp(p, 0, 1) -- inferred equivalent call
		local v2 = data.reach * easeOutQuint(v) -- inferred equivalent call
		local v3 = v * 170 * v
		local v4 = math.sin(data.angle) * v2
		local v5 = v4 >= 0 and 1.5 or 0.6
		return {
			x = math.cos(data.angle) * v2 * 1.4,
			y = v4 * v5 + v3,
			rotation = data.spin * v,
			scale = data.sizeScale * popScale(v), -- inferred equivalent call
			transparency = fadeTransparency(v) -- inferred equivalent call
		}
	end
}
