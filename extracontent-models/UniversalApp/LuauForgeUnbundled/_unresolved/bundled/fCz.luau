local module = require("@luauforge/bundled/dVn")

return function(callback, value)
	assert(type(value) == "string", "EconomyGetCurrency request expects userId to be a string")

	return callback(string.format("%s/v1/users/%s/currency", module.ECONOMY_URL, value), "GET")
end
