local module = require("@luauforge/bundled/dVn")

return function(callback)
	return callback(string.format("%sv1/products", module.PREMIUM_FEATURES), "GET")
end
