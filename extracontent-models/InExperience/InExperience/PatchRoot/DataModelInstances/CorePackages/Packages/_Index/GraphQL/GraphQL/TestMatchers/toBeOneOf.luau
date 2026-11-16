local toArrayContains = require(script.Parent.toArrayContains)

local function toBeOneOf(p, p2)
	return toArrayContains(p2, p)
end

return toBeOneOf
