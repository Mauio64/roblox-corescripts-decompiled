local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")
local module2 = require("@luauforge/bundled/fsq")

return function(callback)
	return callback(module2.new({
		base = Url.USERS_URL,
		path = "users/authenticated/roles"
	})(), "GET")
end
