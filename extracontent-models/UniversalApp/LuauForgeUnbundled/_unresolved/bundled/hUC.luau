local module = require("@luauforge/bundled/gWS")
local module2 = require("@luauforge/bundled/dAB")

return function(p2, p3)
	local v5 = p2 or { Products = nil, FetchingStatus = module2.NotStarted }

	assert(v5, "")

	if p3.type == module.name then
		return { Products = p3.nativeRobuxProducts, FetchingStatus = module2.Done }
	end

	return v5
end
