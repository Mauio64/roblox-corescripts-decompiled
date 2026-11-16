local module = require("@luauforge/bundled/eds")
local module2 = require("@luauforge/bundled/edt")

return {
	spring = function(p2, p3, p4, p5)
		local v5 = p3 or module.DEFAULT_STIFFNESS
		local v6 = p4 or module.DEFAULT_DAMPING
		local v7 = p5 or module.SPRING_PRECISION

		return {
			type = module2.Spring,
			value = p2,
			stiffness = v5,
			damping = v6,
			precision = v7
		}
	end,
	extractValue = function(p2)
		if type(p2) == "table" then
			return p2.value
		end

		return p2
	end,
	getType = function(p2)
		if type(p2) == "table" then
			return p2.type
		end

		return module2.Instant
	end
}
