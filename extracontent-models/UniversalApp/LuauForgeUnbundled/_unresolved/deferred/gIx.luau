local module = require("@luauforge/bundled/dVn")

return function(callback)
	return callback(string.format("%s/users/authenticated", module.USERS_URL), "GET", {
		maxRetryCount = 0
	})
end
