local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback)
	return callback(string.format("%sv1/email", Url.ACCOUNT_SETTINGS_URL), "GET")
end
