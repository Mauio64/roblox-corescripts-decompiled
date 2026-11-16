local HttpService = game:GetService("HttpService")

local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")

return function(callback, value, value2)
	assert(type(value2) == "string", "invalid challenge has been passed into PostVerifyPhoneNumber")
	assert(type(value) == "string", "invalid code has been passed into PostVerifyPhoneNumber")

	return callback(string.format("%sv1/verified-signup/voucher", Url.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({ code = value, challenge = value2 }),
		maxRetryCount = 0
	})
end
