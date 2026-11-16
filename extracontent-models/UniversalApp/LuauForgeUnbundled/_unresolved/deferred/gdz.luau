local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback)
	return callback(("%s/v1/user/currency"):format(Url.ECONOMY_URL), "GET")
end
