local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback)
	return callback(string.format("%sv1/products", Url.PREMIUM_FEATURES), "GET")
end
