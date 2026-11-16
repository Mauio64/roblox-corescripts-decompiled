local HttpService = game:GetService("HttpService")

local Base64 = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/Base64")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Url

local PasskeyConstants = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Common/PasskeyConstants")

local function getFinishRegistrationUrl()
	return string.format("%sv1/passkey/finish-preauth-registration", url.AUTH_URL)
end

local function finishPreauthPasskeyRegistration(callback, jsonEncode)
	return callback(string.format("%sv1/passkey/finish-preauth-registration", url.AUTH_URL), "POST", {
		postBody = jsonEncode
	}):andThen(
		function(p2)
			return Promise.resolve(p2)
		end,
		function(p2)
			local v5 = if type(p2) == "table" then HttpService:JSONEncode(p2) else nil
			return Promise.reject({
				body = v5,
				name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME
			})
		end
	)
end

local function attemptFinishPreauthPasskeyRegistration(p2, p3, json)
	local jsonDecode = HttpService:JSONDecode(json)
	jsonDecode.id = Base64.ToUrlSafeBase64(jsonDecode.id)
	jsonDecode.rawId = Base64.ToUrlSafeBase64(jsonDecode.rawId)
	jsonDecode.response.attestationObject = Base64.ToUrlSafeBase64(jsonDecode.response.attestationObject)
	jsonDecode.response.clientDataJSON = Base64.ToUrlSafeBase64(jsonDecode.response.clientDataJSON)

	return finishPreauthPasskeyRegistration(
		p2,
		HttpService:JSONEncode({
			sessionId = p3,
			registrationResponse = HttpService:JSONEncode(jsonDecode)
		})
	)
end

return attemptFinishPreauthPasskeyRegistration
