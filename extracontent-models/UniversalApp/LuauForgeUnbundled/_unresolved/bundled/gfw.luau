local module = require("@luauforge/bundled/dVn")

return function(callback)
	return callback(string.format("%sv2/stream-notifications/unread-count", module.NOTIFICATION_URL), "GET")
end
