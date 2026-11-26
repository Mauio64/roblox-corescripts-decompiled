local module = require("@luauforge/bundled/dVn")

return function(callback)
	return callback(string.format("%sv1/email", module.ACCOUNT_SETTINGS_URL), "GET")
end
