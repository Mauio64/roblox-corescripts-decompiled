local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback)
	return callback(string.format("%sv2/stream-notifications/unread-count", Url.NOTIFICATION_URL), "GET")
end
