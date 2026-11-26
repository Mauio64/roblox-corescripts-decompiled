require("@luauforge/bundled/hIN")

require("@luauforge/bundled/hIL")
local module = require("@luauforge/bundled/hIO")

local function fetchPurchaseWarnings(p2, p3)
	return module(p2, p3)
end

return fetchPurchaseWarnings
