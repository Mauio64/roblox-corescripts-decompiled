local assign = require(script.Parent.assign)
local abs = math.abs
local exp = math.exp
local sin = math.sin
local cos = math.cos
local sqrt = math.sqrt

local function step(p1, p2, p3) -- line: 20
	-- upvalues: exp (copy), sqrt (copy), cos (copy), sin (copy), abs (copy)
	local __dampingRatio = p1.__dampingRatio
	local v13 = p1.__frequency * 2 * 3.141592653589793
	local __goalPosition = p1.__goalPosition
	local __restingVelocityLimit = p1.__restingVelocityLimit
	local __restingPositionLimit = p1.__restingPositionLimit
	local value = p2.value
	local v18 = p2.velocity or 0
	local v19 = value - __goalPosition
	local v20 = exp(-p3 * __dampingRatio * v13)
	local v21, v22

	if __dampingRatio == 1 then
		v21 = (v18 * p3 + v19 * (v13 * p3 + 1)) * v20 + __goalPosition
		v22 = (v18 - v13 * p3 * (v19 * v13 + v18)) * v20
	elseif __dampingRatio < 1 then
		local v23 = sqrt(1 - __dampingRatio * __dampingRatio)
		local v24 = cos(v13 * v23 * p3)
		local v25 = sin(v13 * v23 * p3)
		local v26

		if v23 > 0.0001 then
			v26 = v25 / v23
		else
			local v27 = p3 * v13

			v26 = v27 + (v27 * v27 * (v23 * v23) * (v23 * v23) / 20 - v23 * v23) * (v27 * v27 * v27) / 6
		end

		local v28

		if v13 * v23 > 0.0001 then
			v28 = v25 / (v13 * v23)
		else
			local v29 = v13 * v23

			v28 = p3 + (p3 * p3 * (v29 * v29) * (v29 * v29) / 20 - v29 * v29) * (p3 * p3 * p3) / 6
		end

		v21 = (v19 * (v24 + __dampingRatio * v26) + v18 * v28) * v20 + __goalPosition
		v22 = (v18 * (v24 - v26 * __dampingRatio) - v19 * (v26 * v13)) * v20
	else
		local v30 = sqrt(__dampingRatio * __dampingRatio - 1)
		local v31 = -v13 * (__dampingRatio - v30)
		local v32 = -v13 * (__dampingRatio + v30)
		local v33 = (v18 - v31 * v19) / (2 * v13 * v30)
		local v34 = (v19 - v33) * exp(v31 * p3)
		local v35 = v33 * exp(v32 * p3)

		v21 = v34 + v35 + __goalPosition
		v22 = v31 * v34 + v32 * v35
	end

	local v36 = abs(v21 - p1.__goalPosition)
	local v37 = __restingVelocityLimit > abs(v22) and v36 < __restingPositionLimit

	if v37 then
		v21 = p1.__goalPosition
		v22 = 0
	end

	return {
		value = v21,
		velocity = v22,
		complete = v37
	}
end
local function spring(p4, p5) -- line: 117
	-- upvalues: assign (copy), step (copy)
	assert(typeof(p4) == "number")

	local t1 = {
		dampingRatio = 1,
		frequency = 1,
		restingVelocityLimit = 0.001,
		restingPositionLimit = 0.01
	}

	if p5 ~= nil then
		assert(typeof(p5) == "table")
		assign(t1, p5)
	end

	local dampingRatio = t1.dampingRatio
	local frequency = t1.frequency
	local restingVelocityLimit = t1.restingVelocityLimit
	local restingPositionLimit = t1.restingPositionLimit

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
		__goalPosition = p4,
		step = step
	}
end

return spring
