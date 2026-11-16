require("@luauforge/bundled/dHK")

local module = require("@luauforge/bundled/ihi")

local module2 = require("@luauforge/bundled/ihj")

return function(p2)
	if module(p2) then
		return true
	end

	return module2(p2)
end
