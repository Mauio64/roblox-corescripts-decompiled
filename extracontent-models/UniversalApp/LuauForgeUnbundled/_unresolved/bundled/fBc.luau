local module = require("@luauforge/bundled/dVn")

return function(callback)
	return callback(string.format("%s/robuxbadge/v1/robuxbadge", module.APIS_URL), "GET")
end
