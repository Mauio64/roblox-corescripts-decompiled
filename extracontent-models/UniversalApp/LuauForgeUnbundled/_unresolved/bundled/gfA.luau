local module = require("@luauforge/bundled/dVn")

return function(callback)
	return callback(string.format("%smaintenance-status/v1/alerts/alert-info", module.APIS_URL), "GET")
end
