local HttpService = game:GetService("HttpService")
local module = require("@luauforge/bundled/dVn")
local module2 = require("@luauforge/bundled/hLG")

return function(callback, p2, value, value2)
	assert(
		p2 == module2.Email or p2 == module2.PhoneNumber,
		"AuthVerifyCredentials request expects credentialType to be a Email or PhoneNumber"
	)

	assert(type(value) == "string", "AuthVerifyCredentials request expects credentialType to be a string")
	assert(type(value2) == "string", "AuthVerifyCredentials request expects password to be a string")

	return callback(string.format("%sv2/credentials/verification/send", module.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({
			credentialType = p2,
			credentialValue = value,
			password = value2
		})
	})
end
