require("@luauforge/bundled/dKT")

local module = require("@luauforge/bundled/ipH")

local module2 = require("@luauforge/bundled/ipI")

return function(p2)
	if module(p2) then
		return true
	end

	return module2(p2)
end
