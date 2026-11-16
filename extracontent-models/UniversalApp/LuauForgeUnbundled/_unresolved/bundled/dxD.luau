local module = require("@luauforge/bundled/dxE")

return function(p2, p3)
	if p3.type == module.name then
		return p3.isSoothsayer
	end

	return p2 or false
end
