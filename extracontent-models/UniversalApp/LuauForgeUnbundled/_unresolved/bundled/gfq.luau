local module = require("@luauforge/bundled/dVn")

return function(callback)
	return callback(string.format("%s/user/friend-requests/count", module.FRIEND_URL), "GET")
end
