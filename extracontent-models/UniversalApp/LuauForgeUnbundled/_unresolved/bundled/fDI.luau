local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, p2)
	return callback(string.format("%sv1/themes/User/%d", Url.ACCOUNT_SETTINGS, p2), "GET")
end
