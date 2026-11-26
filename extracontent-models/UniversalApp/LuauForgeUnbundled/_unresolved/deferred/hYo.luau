local module = require("@luauforge/bundled/dVn")

return function(callback)
	return callback(
		module.APIS_URL .. "identity-verification-service/v1/vietnam/start-verification-form",
		"GET"
	)
end
