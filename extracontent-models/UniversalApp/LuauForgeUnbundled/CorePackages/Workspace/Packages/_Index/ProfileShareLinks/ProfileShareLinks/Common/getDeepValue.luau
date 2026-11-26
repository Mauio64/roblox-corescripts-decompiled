local getDeepValue = require("@luauforge/bundled/ejr").SocialLibraries.config({}).Dictionary.getDeepValue

local module = require("@luauforge/bundled/ejh")

return function(p2, p3, ...)
	local v5 = not p3 and "%s" or "%s." .. p3
	return getDeepValue(p2, string.format(v5, module, unpack({ ... })))
end
