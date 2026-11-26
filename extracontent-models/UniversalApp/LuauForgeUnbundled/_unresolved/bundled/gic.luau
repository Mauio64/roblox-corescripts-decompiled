local module = require("@luauforge/bundled/dVn")

return function(callback, p2)
	return callback(string.format("%sv1/themes/User/%d", module.ACCOUNT_SETTINGS, p2), "GET")
end
