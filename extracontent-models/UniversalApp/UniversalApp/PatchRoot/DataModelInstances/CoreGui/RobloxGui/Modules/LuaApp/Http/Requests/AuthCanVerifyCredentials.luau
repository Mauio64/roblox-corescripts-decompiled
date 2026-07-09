local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local CredentialType = require(Modules.LuaApp.Enum.CredentialType)
local v5 = UrlBuilder.new({
	path = "v2/credentials/verification",
	query = "{credentialType}&{credentialValue}&{password}",
	base = Url.AUTH_URL
})

local function authCanVerifyCredentials(p1, p2, p3, p4) -- line: 22
	-- upvalues: CredentialType (copy), v5 (copy)
	assert(p2 == CredentialType.Email or p2 == CredentialType.PhoneNumber, "AuthCanVerifyCredentials request expects credentialType to be a Email or PhoneNumber")
	assert(type(p3) == "string", "AuthCanVerifyCredentials request expects credentialType to be a string")
	assert(type(p4) == "string", "AuthCanVerifyCredentials request expects password to be a string")

	return p1(v5({
		credentialType = p2,
		credentialValue = p3,
		password = p4
	}), "GET")
end

return authCanVerifyCredentials
