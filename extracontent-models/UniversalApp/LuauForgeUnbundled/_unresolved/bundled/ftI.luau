local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback)
	return callback(string.format("%s/robuxbadge/v1/robuxbadge", Url.APIS_URL), "GET")
end
