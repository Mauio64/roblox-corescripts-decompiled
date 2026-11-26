local module = require("@luauforge/bundled/dVn")

return function(callback)
	return callback(string.format("%sv2/passwords/current-status", module.AUTH_URL), "GET")
end
