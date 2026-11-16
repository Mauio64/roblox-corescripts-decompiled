local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback)
	return callback(string.format("%smaintenance-status/v1/alerts/alert-info", Url.APIS_URL), "GET")
end
