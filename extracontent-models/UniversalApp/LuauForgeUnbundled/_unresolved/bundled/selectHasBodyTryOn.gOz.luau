local module = require("@luauforge/bundled/gqj")

local function selectHasBodyTryOn(p2): boolean
	return #module(p2) > 0
end

return selectHasBodyTryOn
