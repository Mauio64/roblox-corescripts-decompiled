local ParentParent = script.Parent.Parent
local assign = require(ParentParent.Collections).Object.assign

require(script.Parent.types)

local abs = math.abs
local exp = math.exp
local sin = math.sin
local cos = math.cos
local sqrt = math.sqrt

local function translateParameters(n1: number, n2: number, n3: number) -- line: 54
	-- upvalues: sqrt (copy)
	return n1 / (sqrt(n3 * n2) * 2), sqrt(n2 / n3) / 2 / 3.141592653589793
end
local function spring(n4: number, p1) -- line: 60
	-- upvalues: assign (copy), sqrt (copy), exp (copy), cos (copy), sin (copy), abs (copy)
	local t1 = {
		dampingRatio = 1,
		frequency = 1,
		restingVelocityLimit = 0.001,
		restingPositionLimit = 0.01
	}

	if p1 ~= nil then
		assign(t1, p1)
	end

	local restingVelocityLimit = t1.restingVelocityLimit
	local restingPositionLimit = t1.restingPositionLimit
	local damping = t1.damping
	local stiffness = t1.stiffness
	local mass = t1.mass
	local v21, v22

	if typeof(damping) == "number" and typeof(stiffness) == "number" and typeof(mass) == "number" then
		v21 = damping / (sqrt(mass * stiffness) * 2)
		v22 = sqrt(stiffness / mass) / 2 / 3.141592653589793
	else
		v21 = t1.dampingRatio
		v22 = t1.frequency
	end

	local v23 = v21
	local v24 = v22 * 2 * 3.141592653589793

	assert(restingVelocityLimit >= 0, "Expected restingVelocityLimit >= 0")
	assert(restingPositionLimit >= 0, "Expected restingPositionLimit >= 0")

	return {
		step = function(p2, n5: number) -- line: 97
			-- upvalues: n4 (copy), v23 (copy), v24 (copy), exp (copy), sqrt (copy), cos (copy), sin (copy), n4 (copy), abs (copy), restingVelocityLimit (copy), restingPositionLimit (copy)
			local value = p2.value
			local v28 = p2.velocity or 0
			local v29 = value - n4
			local v30 = exp(-n5 * v23 * v24)
			local v31, v32

			if v23 == 1 then
				v31 = (v28 * n5 + v29 * (v24 * n5 + 1)) * v30 + n4
				v32 = (v28 - v24 * n5 * (v29 * v24 + v28)) * v30
			elseif v23 < 1 then
				local v33 = sqrt(1 - v23 * v23)
				local v34 = cos(v24 * v33 * n5)
				local v35 = sin(v24 * v33 * n5)
				local v36

				if v33 > 0.0001 then
					v36 = v35 / v33
				else
					local v37 = n5 * v24

					v36 = v37 + (v37 * v37 * (v33 * v33) * (v33 * v33) / 20 - v33 * v33) * (v37 * v37 * v37) / 6
				end

				local v38

				if v24 * v33 > 0.0001 then
					v38 = v35 / (v24 * v33)
				else
					local v39 = v24 * v33

					v38 = n5 + (n5 * n5 * (v39 * v39) * (v39 * v39) / 20 - v39 * v39) * (n5 * n5 * n5) / 6
				end

				v31 = (v29 * (v34 + v23 * v36) + v28 * v38) * v30 + n4
				v32 = (v28 * (v34 - v36 * v23) - v29 * (v36 * v24)) * v30
			else
				local v40 = sqrt(v23 * v23 - 1)
				local v41 = -v24 * (v23 - v40)
				local v42 = -v24 * (v23 + v40)
				local v43 = (v28 - v41 * v29) / (2 * v24 * v40)
				local v44 = (v29 - v43) * exp(v41 * n5)
				local v45 = v43 * exp(v42 * n5)

				v31 = v44 + v45 + n4
				v32 = v41 * v44 + v42 * v45
			end

			local v46 = abs(v31 - n4)
			local v47 = abs(v32) < restingVelocityLimit and v46 < restingPositionLimit

			if v47 then
				v31 = n4
				v32 = 0
			end

			return {
				value = v31,
				velocity = v32,
				complete = v47
			}
		end,
		startingValue = if not p1 then nil else p1.startingValue
	}
end

return spring
