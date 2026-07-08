local toArrayContains = require(script.Parent.toArrayContains)

local function toBeOneOf(p1, p2) -- line: 17
	-- upvalues: toArrayContains (copy)
	return toArrayContains(p2, p1)
end

return toBeOneOf
