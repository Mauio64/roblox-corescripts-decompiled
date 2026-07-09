local Config = require(script.Parent.Config)
local MotionType = require(script.Parent.MotionType)

return {
	spring = function(n1: number, n2: number?, n3: number?, n4: number?) -- line: 18
		-- upvalues: Config (copy), MotionType (copy)
		local v7 = n2 or Config.DEFAULT_STIFFNESS
		local v8 = n3 or Config.DEFAULT_DAMPING
		local v9 = n4 or Config.SPRING_PRECISION

		return {
			type = MotionType.Spring,
			value = n1,
			stiffness = v7,
			damping = v8,
			precision = v9
		}
	end,
	extractValue = function(p1) -- line: 35
		if type(p1) == "table" then
			return p1.value
		end

		return p1
	end,
	getType = function(p2) -- line: 46
		-- upvalues: MotionType (copy)
		if type(p2) == "table" then
			return p2.type
		end

		return MotionType.Instant
	end
}
