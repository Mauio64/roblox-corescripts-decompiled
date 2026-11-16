local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback)
	return callback(string.format("%sv1/account/pin", Url.AUTH_URL), "GET")
end
