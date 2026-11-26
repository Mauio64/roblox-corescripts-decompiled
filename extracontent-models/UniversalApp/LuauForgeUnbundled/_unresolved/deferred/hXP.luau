local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dVn")

return function(callback, value)
	assert(type(value) == "string", "invalid account PIN")

	return callback(string.format("%sv1/account/pin/unlock", module.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({ pin = value })
	})
end
