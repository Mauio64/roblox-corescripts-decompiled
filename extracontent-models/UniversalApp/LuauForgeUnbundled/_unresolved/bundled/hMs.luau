local HttpService = game:GetService("HttpService")
local module = require("@luauforge/bundled/dVn")

return function(callback, value)
	assert(type(value) == "string", "invalid delivery target")
	return callback(string.format("%sv1/verified-signup/challenge", module.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({ deliveryMethod = 0, deliveryTarget = value })
	})
end
