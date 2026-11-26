local module = require("@luauforge/bundled/dVn")
local module2 = require("@luauforge/bundled/gCu")

return function(callback, p2, p3)
	local v5 = module2()
	return callback(
		string.format(
			"%sexperience-store/v1/universes/%s/store?limit=%d&cursor=%s",
			module.APIS_URL,
			p2,
			v5,
			p3
		),
		"GET"
	)
end
