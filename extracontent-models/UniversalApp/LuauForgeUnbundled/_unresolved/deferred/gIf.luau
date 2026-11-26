local module = require("@luauforge/bundled/dVn")

return function(callback)
	return callback(("%s/v1/user/currency"):format(module.ECONOMY_URL), "GET")
end
