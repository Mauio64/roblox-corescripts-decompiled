local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback)
	return callback(string.format("%s/user/friend-requests/count", Url.FRIEND_URL), "GET")
end
