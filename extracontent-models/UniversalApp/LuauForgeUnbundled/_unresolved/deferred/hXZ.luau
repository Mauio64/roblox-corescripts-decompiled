local module = require("@luauforge/bundled/dVn")

return function(callback)
	return callback(string.format("%sv1/account/pin/lock", module.AUTH_URL), "POST", {
		postBody = ""
	})
end
