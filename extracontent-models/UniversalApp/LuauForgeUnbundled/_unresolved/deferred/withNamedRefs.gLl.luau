local module = require("@luauforge/deferred/gLm")
local module2 = require("@luauforge/bundled/fAf")

local function withNamedRefs(p2)
	return module2(p2, module.Consumer, "namedRefs")
end

return withNamedRefs
