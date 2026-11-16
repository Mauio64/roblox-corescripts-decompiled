local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback)
	return callback(string.format("%sv1/account/pin/lock", Url.AUTH_URL), "POST", {
		postBody = ""
	})
end
