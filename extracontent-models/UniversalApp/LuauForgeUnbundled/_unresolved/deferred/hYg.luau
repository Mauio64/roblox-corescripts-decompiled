local module = require("@luauforge/bundled/dVn")

return function(callback)
	return callback(string.format("%sv1/account/pin", module.AUTH_URL), "GET")
end
