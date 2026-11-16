local assign = require(script.Parent.assign)

local abs = math.abs
local exp = math.exp
local sin = math.sin
local cos = math.cos
local sqrt = math.sqrt

local function step(data, p, p2)
	local __dampingRatio = data.__dampingRatio
	local v = data.__frequency * 2 * 3.141592653589793
	local __goalPosition = data.__goalPosition
	local __restingVelocityLimit = data.__restingVelocityLimit
	local __restingPositionLimit = data.__restingPositionLimit

	local value = p.value
	local velocity = p.velocity or 0

	local v2 = value - __goalPosition
	local v3 = exp(-p2 * __dampingRatio * v)
	local v4, velocity2

	if __dampingRatio == 1 then
		v4 = (velocity * p2 + v2 * (v * p2 + 1)) * v3 + __goalPosition
		velocity2 = (velocity - v * p2 * (v2 * v + velocity)) * v3
	elseif __dampingRatio < 1 then
		local v5 = sqrt(1 - __dampingRatio * __dampingRatio)

		local v6 = cos(v * v5 * p2)
		local v7 = sin(v * v5 * p2)
		local v8

		if v5 > 0.0001 then
			v8 = v7 / v5
		else
			local v9 = p2 * v
			v8 = v9 + (v9 * v9 * (v5 * v5) * (v5 * v5) / 20 - v5 * v5) * (v9 * v9 * v9) / 6
		end

		local v9

		if v * v5 > 0.0001 then
			v9 = v7 / (v * v5)
		else
			local v10 = v * v5
			v9 = p2 + (p2 * p2 * (v10 * v10) * (v10 * v10) / 20 - v10 * v10) * (p2 * p2 * p2) / 6
		end

		v4 = (v2 * (v6 + __dampingRatio * v8) + velocity * v9) * v3 + __goalPosition
		velocity2 = (velocity * (v6 - v8 * __dampingRatio) - v2 * (v8 * v)) * v3
	else
		local v5 = sqrt(__dampingRatio * __dampingRatio - 1)

		local v6 = -v * (__dampingRatio - v5)
		local v7 = -v * (__dampingRatio + v5)

		local v8 = (velocity - v6 * v2) / (2 * v * v5)
		local v9 = (v2 - v8) * exp(v6 * p2)
		local v10 = v8 * exp(v7 * p2)

		v4 = v9 + v10 + __goalPosition
		velocity2 = v6 * v9 + v7 * v10
	end

	local v5 = abs(v4 - data.__goalPosition)
	local complete

	if abs(velocity2) < __restingVelocityLimit then
		complete = v5 < __restingPositionLimit
	else
		complete = false
	end

	if complete then
		v4 = data.__goalPosition
		velocity2 = 0
	end

	return { value = v4, velocity = velocity2, complete = complete }
end

local function spring(goalPosition, p)
	assert(typeof(goalPosition) == "number")

	local v = {
		dampingRatio = 1,
		frequency = 1,
		restingVelocityLimit = 0.001,
		restingPositionLimit = 0.01
	}

	if p ~= nil then
		assert(typeof(p) == "table")
		assign(v, p)
	end

	local dampingRatio = v.dampingRatio
	local frequency = v.frequency
	local restingVelocityLimit = v.restingVelocityLimit
	local restingPositionLimit = v.restingPositionLimit

	assert(typeof(dampingRatio) == "number")
	assert(typeof(frequency) == "number")
	assert(typeof(restingVelocityLimit) == "number")
	assert(typeof(restingPositionLimit) == "number")

	assert(restingVelocityLimit >= 0, "Expected restingVelocityLimit >= 0")
	assert(restingPositionLimit >= 0, "Expected restingPositionLimit >= 0")

	return {
		__dampingRatio = dampingRatio,
		__frequency = frequency,
		__restingVelocityLimit = restingVelocityLimit,
		__restingPositionLimit = restingPositionLimit,
		__goalPosition = goalPosition,
		step = step
	}
end

return spring
