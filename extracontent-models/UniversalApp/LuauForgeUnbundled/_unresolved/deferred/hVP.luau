local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dVn")

return function(callback, value, value2)
	assert(type(value2) == "string", "invalid challenge has been passed into PostVerifyPhoneNumber")
	assert(type(value) == "string", "invalid code has been passed into PostVerifyPhoneNumber")

	return callback(string.format("%sv1/verified-signup/voucher", module.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({ code = value, challenge = value2 }),
		maxRetryCount = 0
	})
end
