local Constants = require(script.Parent.Constants)

local function normalizeUnifiedGetCredentialsResponse(response)
	if typeof(response) ~= "table" or (response.credentialType ~= nil or response.errorCode ~= nil) then
		return response
	end

	if typeof(response.id) == "string" and typeof(response.response) == "table" then
		return { credentialType = Constants.CredentialsTypes.FIDO2, response = response }
	end

	return response
end

return normalizeUnifiedGetCredentialsResponse
