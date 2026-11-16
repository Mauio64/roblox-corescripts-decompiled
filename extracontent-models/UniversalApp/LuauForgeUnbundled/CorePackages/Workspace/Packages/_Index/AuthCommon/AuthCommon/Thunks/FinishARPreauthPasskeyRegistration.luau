local HttpService = game:GetService("HttpService")

local Base64 = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/Base64")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Url

local PasskeyConstants = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Common/PasskeyConstants")

local fFlagEmitPasskeyRegistrationSourceOnFinish = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEmitPasskeyRegistrationSourceOnFinish

local function getFinishRegistrationUrl()
	return string.format("%sv1/passkey/finish-ar-preauth-registration", url.AUTH_URL)
end

local function finishARPreauthPasskeyRegistration(callback, jsonEncode)
	return callback(string.format("%sv1/passkey/finish-ar-preauth-registration", url.AUTH_URL), "POST", {
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

local function attemptFinishARPreauthPasskeyRegistration(p2, p3, p4, p5, json, p6, source)
	local jsonDecode = HttpService:JSONDecode(json)
	jsonDecode.id = Base64.ToUrlSafeBase64(jsonDecode.id)
	jsonDecode.rawId = Base64.ToUrlSafeBase64(jsonDecode.rawId)
	jsonDecode.response.attestationObject = Base64.ToUrlSafeBase64(jsonDecode.response.attestationObject)
	jsonDecode.response.clientDataJSON = Base64.ToUrlSafeBase64(jsonDecode.response.clientDataJSON)

	local v5 = {
		recoverySession = p3,
		passkeySessionId = p4,
		passkeyRegistrationResponse = HttpService:JSONEncode(jsonDecode),
		userId = p5,
		isPostRecovery = p6,
		source = 0
	}

	if not fFlagEmitPasskeyRegistrationSourceOnFinish then
		source = nil
	end

	v5.source = source

	return finishARPreauthPasskeyRegistration(p2, HttpService:JSONEncode(v5))
end

return attemptFinishARPreauthPasskeyRegistration
