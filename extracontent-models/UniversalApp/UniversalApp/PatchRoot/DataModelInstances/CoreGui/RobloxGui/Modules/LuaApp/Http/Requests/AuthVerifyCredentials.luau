local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local Url = require(Modules.LuaApp.Http.Url)
local CredentialType = require(Modules.LuaApp.Enum.CredentialType)

return function(p1, p2, p3, p4) -- line: 16
	-- upvalues: CredentialType (copy), Url (copy), HttpService (copy)
	assert(p2 == CredentialType.Email or p2 == CredentialType.PhoneNumber, "AuthVerifyCredentials request expects credentialType to be a Email or PhoneNumber")
	assert(type(p3) == "string", "AuthVerifyCredentials request expects credentialType to be a string")
	assert(type(p4) == "string", "AuthVerifyCredentials request expects password to be a string")

	return p1(string.format("%sv2/credentials/verification/send", Url.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({
			credentialType = p2,
			credentialValue = p3,
			password = p4
		})
	})
end
