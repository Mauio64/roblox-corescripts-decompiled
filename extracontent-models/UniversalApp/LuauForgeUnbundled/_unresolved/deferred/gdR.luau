local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback)
	return callback(string.format("%s/users/authenticated", Url.USERS_URL), "GET", {
		maxRetryCount = 0
	})
end
