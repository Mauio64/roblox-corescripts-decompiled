local module = require("@luauforge/bundled/fsq")
local module2 = require("@luauforge/bundled/fyc")

local function buildCreatorWebNavUrl(p2)
	return module.addQueryString(module.static.creatorHub(), module2(p2))
end

return buildCreatorWebNavUrl
