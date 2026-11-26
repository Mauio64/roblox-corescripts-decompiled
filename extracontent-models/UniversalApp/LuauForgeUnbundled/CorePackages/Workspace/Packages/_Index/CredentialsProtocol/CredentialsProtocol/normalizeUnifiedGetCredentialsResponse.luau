local Constants = require("@game/CorePackages/Workspace/Packages/_Index/CredentialsProtocol/CredentialsProtocol/Constants")

local function normalizeUnifiedGetCredentialsResponse(data)
	if typeof(data) ~= "table" or (data.credentialType ~= nil or data.errorCode ~= nil) then
		return data
	end

	if typeof(data.id) == "string" and typeof(data.response) == "table" then
		return { credentialType = Constants.CredentialsTypes.FIDO2, response = data }
	end

	return data
end

return normalizeUnifiedGetCredentialsResponse
