local HttpService = game:GetService("HttpService")
local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Base64 = require(AuthCommon.Utils.Base64)
local Promise = require(AuthCommonParent.Promise)
local Url = require(AuthCommonParent.Http).Url
local PasskeyConstants = require(AuthCommon.Common.PasskeyConstants)

local function getFinishRegistrationUrl() -- line: 13
	-- upvalues: Url (copy)
	return string.format("%sv1/passkey/finish-ar-preauth-registration", Url.AUTH_URL)
end
local function finishARPreauthPasskeyRegistration(p1, p2) -- line: 17
	-- upvalues: Url (copy), Promise (copy), HttpService (copy), PasskeyConstants (copy)
	return p1(string.format("%sv1/passkey/finish-ar-preauth-registration", Url.AUTH_URL), "POST", {
		postBody = p2
	}):andThen(function(p3) -- line: 18
		-- upvalues: Promise (copy)
		return Promise.resolve(p3)
	end, function(p4) -- line: 20
		-- upvalues: HttpService (copy), Promise (copy), PasskeyConstants (copy)
		local v25 = if type(p4) ~= "table" then nil else HttpService:JSONEncode(p4)

		return Promise.reject({
			body = v25,
			name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME
		})
	end)
end
local function attemptFinishARPreauthPasskeyRegistration(p5, p6, p7, p8, p9, p10) -- line: 26
	-- upvalues: HttpService (copy), Base64 (copy), finishARPreauthPasskeyRegistration (copy)
	local data = HttpService:JSONDecode(p9)

	data.id = Base64.ToUrlSafeBase64(data.id)
	data.rawId = Base64.ToUrlSafeBase64(data.rawId)
	data.response.attestationObject = Base64.ToUrlSafeBase64(data.response.attestationObject)
	data.response.clientDataJSON = Base64.ToUrlSafeBase64(data.response.clientDataJSON)

	local json = HttpService:JSONEncode(data)
	local t1 = {
		recoverySession = p6,
		passkeySessionId = p7,
		passkeyRegistrationResponse = json,
		userId = p8,
		isPostRecovery = p10
	}
	local json2 = HttpService:JSONEncode(t1)

	return finishARPreauthPasskeyRegistration(p5, json2)
end

return attemptFinishARPreauthPasskeyRegistration
