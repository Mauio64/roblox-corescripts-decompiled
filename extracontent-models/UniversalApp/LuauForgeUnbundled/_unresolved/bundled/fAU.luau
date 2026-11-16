local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback)
	return callback(string.format("%sv2/passwords/current-status", Url.AUTH_URL), "GET")
end
