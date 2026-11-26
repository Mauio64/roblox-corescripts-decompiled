require("@luauforge/bundled/dKT")

local module = require("@luauforge/bundled/fCe")

return function(p2): boolean
	return module.getEquippedToolId(p2) ~= nil
end
