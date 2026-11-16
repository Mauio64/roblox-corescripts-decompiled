local module = require("@luauforge/bundled/gxs")

return function(options, p2)
	return p2.type == module.name and { restrictionDetail = p2.restrictionDetail } or options or {}
end
