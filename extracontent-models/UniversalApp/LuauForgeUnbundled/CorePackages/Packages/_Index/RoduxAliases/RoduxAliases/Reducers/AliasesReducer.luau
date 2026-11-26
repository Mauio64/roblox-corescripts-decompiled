local module = require("@luauforge/deferred/dZQ")

local v5 = { byUserId = {} }

return function(p2)
	local v6 = module(p2)

	return function(p3, p4)
		return v6(p3 or v5, p4)
	end
end
