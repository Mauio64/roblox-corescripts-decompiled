require(script.Parent.types)

local function linear(p: number, _)
	return p
end

local function quad(p: number, _)
	return p * p
end

local function cubic(p: number, _)
	return p * p * p
end

local function quart(p: number, _)
	return p * p * p * p
end

local function quint(p: number, _)
	return p * p * p * p * p
end

local function exponential(p: number, _)
	if p == 0 then
		return 0
	end

	return (math.pow(2, (p - 1) * 10))
end

local function sine(p: number, _)
	return 1 - math.cos(p * 3.141592653589793 / 2)
end

local function elastic(p: number, _)
	if p == 0 then
		return 0
	elseif p == 1 then
		return 1
	end

	return -math.pow(2, p * 10 - 10) * math.sin((p * 10 - 10.75) * 2.0943951023931953)
end

local function back(p: number, _)
	return p * 2.70158 * p * p - p * 1.70158 * p
end

local function easeOutBounce(p: number) -- 1 equivalent call inferred from this helper
	if p < 4 / 11 then
		return p * 7.5625 * p
	end

	if p < 8 / 11 then
		return (p - 6 / 11) * 7.5625 * (p - 6 / 11) + 0.75
	end

	if p < 10 / 11 then
		return (p - 9 / 11) * 7.5625 * (p - 9 / 11) + 0.9375
	end

	return (p - 21 / 22) * 7.5625 * (p - 21 / 22) + 0.984375
end

local function bounce(p: number, _)
	return 1 - easeOutBounce(1 - p) -- inferred equivalent call
end

local function circular(p: number, _)
	return -(math.sqrt(1 - p * p) - 1)
end

local function evaluateBezier(p: number, p2: number, p3: number) -- 3 equivalent calls inferred from this helper
	local v = 1 - p
	local v2 = v * v
	local v3 = p * p

	return v2 * 3 * p * p2 + v * 3 * v3 * p3 + p * v3
end

local function cubicBezier(p: number, list)
	assert(typeof(list) == "table", "Expected values to be a table")
	assert(#list == 4, "Expected values to have 4 elements")

	local v, v2, v3, v4 = table.unpack(list)

	local v5 = v >= 0 and v <= 1
	assert(v5, "x1 must be between 0 and 1")
	local v6 = v3 >= 0 and v3 <= 1
	assert(v6, "x2 must be between 0 and 1")

	if p <= 0 then
		return 0
	end

	if p >= 1 then
		return 1
	end

	local count = 0
	local v7 = 0
	local v8 = 1

	for _ = 1, 10 do
		count += 1
		local midpoint = (v7 + v8) / 2
		local bezier = evaluateBezier(midpoint, v, v3) -- inferred equivalent call

		if math.abs(bezier - p) < 0.0001 then
			return evaluateBezier(midpoint, v2, v4) -- inferred equivalent call
		elseif bezier < p then
			v7 = midpoint
		else
			v8 = midpoint
		end
	end

	return evaluateBezier((v7 + v8) / 2, v2, v4) -- inferred equivalent call
end

local v = {
	[Enum.EasingStyle.Linear] = linear,
	[Enum.EasingStyle.Quad] = quad,
	[Enum.EasingStyle.Cubic] = cubic,
	[Enum.EasingStyle.Quart] = quart,
	[Enum.EasingStyle.Quint] = quint,
	[Enum.EasingStyle.Exponential] = exponential,
	[Enum.EasingStyle.Sine] = sine,
	[Enum.EasingStyle.Back] = back,
	[Enum.EasingStyle.Bounce] = bounce,
	[Enum.EasingStyle.Elastic] = elastic,
	[Enum.EasingStyle.Circular] = circular
}

local function ease(goal: number, data)
	local v2 = not (data and data.duration) and 1 or data.duration
	local v3

	if data and data.easingStyle then
		v3 = data.easingStyle
	else
		v3 = Enum.EasingStyle.Linear
	end

	local v4

	if typeof(v3) == "EnumItem" or typeof(v3) == "string" then
		v4 = v[v3]
	else
		v4 = cubicBezier
	end

	local v5 = {
		step = function(data2, p: number)
			local initialValue

			if data2.initialValue == nil then
				initialValue = data2.value or 0
			else
				initialValue = data2.initialValue
			end

			local elapsed = (data2.elapsed or 0) + p

			if data2.goal and goal ~= data2.goal then
				initialValue = data2.value
				elapsed = 0
			end

			local v5 = v4(math.min(elapsed / v2, 1), v3)

			local v6 = initialValue + (goal - initialValue) * v5
			local complete = v2 <= elapsed or initialValue == goal

			if complete then
				v6 = goal

				initialValue = goal
				elapsed = 0
			end

			return {
				initialValue = initialValue,
				goal = goal,
				value = v6,
				elapsed = elapsed,
				complete = complete
			}
		end,
		startingValue = 0
	}
	local startingValue

	if data then
		startingValue = data.startingValue
	end

	v5.startingValue = startingValue
	return v5
end

return ease
