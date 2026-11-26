local module = require("@luauforge/bundled/dVn")
local module2 = require("@luauforge/bundled/fzK")
local module3 = require("@luauforge/bundled/hLG")

local v5 = module2.new({
	base = module.AUTH_URL,
	path = "v2/credentials/verification",
	query = "{credentialType}&{credentialValue}&{password}"
})

local function authCanVerifyCredentials(callback, p2, value, value2)
	assert(
		p2 == module3.Email or p2 == module3.PhoneNumber,
		"AuthCanVerifyCredentials request expects credentialType to be a Email or PhoneNumber"
	)

	assert(
		type(value) == "string",
		"AuthCanVerifyCredentials request expects credentialType to be a string"
	)
	assert(type(value2) == "string", "AuthCanVerifyCredentials request expects password to be a string")

	return callback(v5({
		credentialType = p2,
		credentialValue = value,
		password = value2
	}), "GET")
end

return authCanVerifyCredentials
