local module = require("@luauforge/deferred/ggG")
local module2 = require("@luauforge/bundled/fsL")

local function withNamedRefs(p2)
	return module2(p2, module.Consumer, "namedRefs")
end

return withNamedRefs
