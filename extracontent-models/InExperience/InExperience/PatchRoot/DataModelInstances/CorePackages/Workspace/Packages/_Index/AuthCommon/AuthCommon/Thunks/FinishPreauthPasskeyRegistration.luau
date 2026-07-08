local HttpService = game:GetService("HttpService")
local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Base64 = require(AuthCommon.Utils.Base64)
local Promise = require(AuthCommonParent.Promise)
local Url = require(AuthCommonParent.Http).Url
local PasskeyConstants = require(AuthCommon.Common.PasskeyConstants)

local function getFinishRegistrationUrl() -- line: 14
	-- upvalues: Url (copy)
	return string.format("%sv1/passkey/finish-preauth-registration", Url.AUTH_URL)
end
local function finishPreauthPasskeyRegistration(p1, p2) -- line: 18
	-- upvalues: Url (copy), Promise (copy), HttpService (copy), PasskeyConstants (copy)
	return p1(string.format("%sv1/passkey/finish-preauth-registration", Url.AUTH_URL), "POST", {
		postBody = p2
	}):andThen(function(p3) -- line: 19
		-- upvalues: Promise (copy)
		return Promise.resolve(p3)
	end, function(p4) -- line: 21
		-- upvalues: HttpService (copy), Promise (copy), PasskeyConstants (copy)
		local v22 = if type(p4) ~= "table" then nil else HttpService:JSONEncode(p4)

		return Promise.reject({
			body = v22,
			name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME
		})
	end)
end
local function attemptFinishPreauthPasskeyRegistration(p5, p6, p7) -- line: 27
	-- upvalues: HttpService (copy), Base64 (copy), finishPreauthPasskeyRegistration (copy)
	local data = HttpService:JSONDecode(p7)

	data.id = Base64.ToUrlSafeBase64(data.id)
	data.rawId = Base64.ToUrlSafeBase64(data.rawId)
	data.response.attestationObject = Base64.ToUrlSafeBase64(data.response.attestationObject)
	data.response.clientDataJSON = Base64.ToUrlSafeBase64(data.response.clientDataJSON)

	local json = HttpService:JSONEncode(data)
	local t1 = {
		sessionId = p6,
		registrationResponse = json
	}
	local json2 = HttpService:JSONEncode(t1)

	return finishPreauthPasskeyRegistration(p5, json2)
end

return attemptFinishPreauthPasskeyRegistration
