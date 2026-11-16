local HttpService = game:GetService("HttpService")
local AuthCommon = script:FindFirstAncestor("AuthCommon")

local parent = AuthCommon.Parent
local Base64 = require(AuthCommon.Utils.Base64)
local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url

local PasskeyConstants = require(AuthCommon.Common.PasskeyConstants)

local SharedFlags = require(parent.SharedFlags)
local FFlagEmitPasskeyRegistrationSourceOnFinish = SharedFlags.FFlagEmitPasskeyRegistrationSourceOnFinish

local function getFinishRegistrationUrl() -- 1 equivalent call inferred from this helper
	return string.format("%sv1/passkey/finish-ar-preauth-registration", Url.AUTH_URL)
end

local function finishARPreauthPasskeyRegistration(callback, postBody)
	return callback(getFinishRegistrationUrl(), "POST", { postBody = postBody }):andThen(function(p) -- inferred equivalent call
		return Promise.resolve(p)
	end, function(p)
		local body

		if type(p) == "table" then
			body = HttpService:JSONEncode(p)
		end

		return Promise.reject({ body = body, name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME })
	end)
end

local function attemptFinishARPreauthPasskeyRegistration(p, recoverySession, passkeySessionId, userId, json, isPostRecovery, source)
	local jsonDecode = HttpService:JSONDecode(json)
	jsonDecode.id = Base64.ToUrlSafeBase64(jsonDecode.id)
	jsonDecode.rawId = Base64.ToUrlSafeBase64(jsonDecode.rawId)
	jsonDecode.response.attestationObject = Base64.ToUrlSafeBase64(jsonDecode.response.attestationObject)
	jsonDecode.response.clientDataJSON = Base64.ToUrlSafeBase64(jsonDecode.response.clientDataJSON)

	local v = {
		recoverySession = recoverySession,
		passkeySessionId = passkeySessionId,
		passkeyRegistrationResponse = HttpService:JSONEncode(jsonDecode),
		userId = userId,
		isPostRecovery = isPostRecovery,
		source = 0
	}

	if not FFlagEmitPasskeyRegistrationSourceOnFinish then
		source = nil
	end

	v.source = source

	return finishARPreauthPasskeyRegistration(p, HttpService:JSONEncode(v))
end

return attemptFinishARPreauthPasskeyRegistration
