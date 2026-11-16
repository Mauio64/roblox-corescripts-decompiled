local parent = script.Parent.Parent
local Collections = require(parent.Collections)
local assign = Collections.Object.assign

require(script.Parent.types)

local abs = math.abs
local exp = math.exp
local sin = math.sin
local cos = math.cos
local sqrt = math.sqrt

local function translateParameters(p: number, p2: number, p3: number)
	return p / (sqrt(p3 * p2) * 2), sqrt(p2 / p3) / 2 / 3.141592653589793
end

local function spring(p: number, p2)
	local v = {
		dampingRatio = 1,
		frequency = 1,
		restingVelocityLimit = 0.001,
		restingPositionLimit = 0.01
	}

	if p2 ~= nil then
		assign(v, p2)
	end

	local restingVelocityLimit = v.restingVelocityLimit
	local restingPositionLimit = v.restingPositionLimit

	local damping = v.damping
	local stiffness = v.stiffness
	local mass = v.mass
	local v2, v3

	if typeof(damping) == "number" and typeof(stiffness) == "number" and typeof(mass) == "number" then
		v2 = damping / (sqrt(mass * stiffness) * 2)
		v3 = sqrt(stiffness / mass) / 2 / 3.141592653589793
	else
		v2 = v.dampingRatio
		v3 = v.frequency
	end

	local v4 = v3 * 2 * 3.141592653589793

	assert(restingVelocityLimit >= 0, "Expected restingVelocityLimit >= 0")
	assert(restingPositionLimit >= 0, "Expected restingPositionLimit >= 0")

	local v5 = {
		step = function(p3, p4: number)
			local value = p3.value
			local velocity = p3.velocity or 0

			local v5 = value - p
			local v6 = exp(-p4 * v2 * v4)
			local v7, velocity2

			if v2 == 1 then
				v7 = (velocity * p4 + v5 * (v4 * p4 + 1)) * v6 + p
				velocity2 = (velocity - v4 * p4 * (v5 * v4 + velocity)) * v6
			elseif v2 < 1 then
				local v8 = sqrt(1 - v2 * v2)

				local v9 = cos(v4 * v8 * p4)
				local v10 = sin(v4 * v8 * p4)
				local v11

				if v8 > 0.0001 then
					v11 = v10 / v8
				else
					local v12 = p4 * v4
					v11 = v12 + (v12 * v12 * (v8 * v8) * (v8 * v8) / 20 - v8 * v8) * (v12 * v12 * v12) / 6
				end

				local v12

				if v4 * v8 > 0.0001 then
					v12 = v10 / (v4 * v8)
				else
					local v13 = v4 * v8
					v12 = p4 + (p4 * p4 * (v13 * v13) * (v13 * v13) / 20 - v13 * v13) * (p4 * p4 * p4) / 6
				end

				v7 = (v5 * (v9 + v2 * v11) + velocity * v12) * v6 + p
				velocity2 = (velocity * (v9 - v11 * v2) - v5 * (v11 * v4)) * v6
			else
				local v8 = sqrt(v2 * v2 - 1)

				local v9 = -v4 * (v2 - v8)
				local v10 = -v4 * (v2 + v8)

				local v11 = (velocity - v9 * v5) / (2 * v4 * v8)
				local v12 = (v5 - v11) * exp(v9 * p4)
				local v13 = v11 * exp(v10 * p4)

				v7 = v12 + v13 + p
				velocity2 = v9 * v12 + v10 * v13
			end

			local v8 = abs(v7 - p)
			local complete

			if abs(velocity2) < restingVelocityLimit then
				complete = v8 < restingPositionLimit
			else
				complete = false
			end

			if complete then
				v7 = p
				velocity2 = 0
			end

			return { value = v7, velocity = velocity2, complete = complete }
		end,
		startingValue = 0
	}
	local startingValue

	if p2 then
		startingValue = p2.startingValue
	end

	v5.startingValue = startingValue
	return v5
end

return spring
