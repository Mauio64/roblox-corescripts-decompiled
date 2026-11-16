local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")
local v5 = require("@luauforge/bundled/fsq").new({
	base = Url.AUTH_URL,
	path = "v3/signup/bundles"
})

return function(callback)
	return callback(v5(), "GET")
end
