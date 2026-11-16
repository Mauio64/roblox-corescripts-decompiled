require("@luauforge/bundled/dHK")

local module = require("@luauforge/bundled/fuD")

return function(p2): boolean
	return module.getEquippedToolId(p2) ~= nil
end
