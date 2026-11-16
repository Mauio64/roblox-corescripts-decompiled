local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")
local module2 = require("@luauforge/bundled/fXy")

return function(callback, p2, p3)
	local v5 = module2()
	return callback(
		string.format(
			"%sexperience-store/v1/universes/%s/store?limit=%d&cursor=%s",
			Url.APIS_URL,
			p2,
			v5,
			p3
		),
		"GET"
	)
end
