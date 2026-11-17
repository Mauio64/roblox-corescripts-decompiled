local HttpService = game:GetService("HttpService")
local AuthCommon = script:FindFirstAncestor("AuthCommon")

local parent = AuthCommon.Parent
local Base64 = require(AuthCommon.Utils.Base64)
local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url

local PasskeyConstants = require(AuthCommon.Common.PasskeyConstants)

local function getFinishRegistrationUrl() -- 1 equivalent call inferred from this helper
	return string.format("%sv1/passkey/finish-preauth-registration", Url.AUTH_URL)
end

local function finishPreauthPasskeyRegistration(callback, jsonEncode)
	return callback(getFinishRegistrationUrl(), "POST", { postBody = jsonEncode }):andThen(function(p) -- inferred equivalent call
		return Promise.resolve(p)
	end, function(p)
		local body

		if type(p) == "table" then
			body = HttpService:JSONEncode(p)
		end

		return Promise.reject({ body = body, name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME })
	end)
end

local function attemptFinishPreauthPasskeyRegistration(p, sessionId, json)
	local jsonDecode = HttpService:JSONDecode(json)
	jsonDecode.id = Base64.ToUrlSafeBase64(jsonDecode.id)
	jsonDecode.rawId = Base64.ToUrlSafeBase64(jsonDecode.rawId)
	jsonDecode.response.attestationObject = Base64.ToUrlSafeBase64(jsonDecode.response.attestationObject)
	jsonDecode.response.clientDataJSON = Base64.ToUrlSafeBase64(jsonDecode.response.clientDataJSON)

	return finishPreauthPasskeyRegistration(
		p,
		HttpService:JSONEncode({
			sessionId = sessionId,
			registrationResponse = HttpService:JSONEncode(jsonDecode)
		})
	)
end

return attemptFinishPreauthPasskeyRegistration
