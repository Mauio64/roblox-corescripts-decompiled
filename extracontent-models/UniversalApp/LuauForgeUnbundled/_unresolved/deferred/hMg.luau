local HttpService = game:GetService("HttpService")
local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")
local module2 = require("@luauforge/bundled/hAr")

return function(callback, p2, value, value2)
	assert(
		p2 == module2.Email or p2 == module2.PhoneNumber,
		"AuthVerifyCredentials request expects credentialType to be a Email or PhoneNumber"
	)

	assert(type(value) == "string", "AuthVerifyCredentials request expects credentialType to be a string")
	assert(type(value2) == "string", "AuthVerifyCredentials request expects password to be a string")

	return callback(string.format("%sv2/credentials/verification/send", Url.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({
			credentialType = p2,
			credentialValue = value,
			password = value2
		})
	})
end
