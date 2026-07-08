local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Base64 = require(AuthCommon.Utils.Base64)
local Promise = require(AuthCommonParent.Promise)
local Url = require(AuthCommonParent.Http).Url
local default = require(AuthCommonParent.CredentialsProtocol).CredentialsProtocol.default
local Logger = require(AuthCommonParent.Loggers).Logger
local PasskeyConstants = require(AuthCommon.Common.PasskeyConstants)

local function getFinishRegistrationUrl() -- line: 16
	-- upvalues: Url (copy)
	return string.format("%sv1/passkey/FinishRegistration", Url.AUTH_URL)
end
local function finishPasskeyRegistration(p1, p2) -- line: 20
	-- upvalues: Url (copy), Promise (copy), HttpService (copy), PasskeyConstants (copy)
	return p1(string.format("%sv1/passkey/FinishRegistration", Url.AUTH_URL), "POST", {
		postBody = p2
	}):andThen(function(p3) -- line: 21
		-- upvalues: Promise (copy)
		return Promise.resolve(p3)
	end, function(p4) -- line: 23
		-- upvalues: HttpService (copy), Promise (copy), PasskeyConstants (copy)
		local v30 = if type(p4) ~= "table" then nil else HttpService:JSONEncode(p4)

		return Promise.reject({
			body = v30,
			name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME,
			source = PasskeyConstants.FINISH_STEP
		})
	end)
end
local function getStartRegistrationUrl(p5) -- line: 34
	-- upvalues: Url (copy)
	local v19 = string.format("%sv1/passkey/StartRegistration", Url.AUTH_URL)

	if p5 then
		return string.format("%s?flow=%s", v19, p5)
	end

	return v19
end
local function startPasskeyRegistration(p6, p7, p8) -- line: 49
	-- upvalues: HttpService (copy), Url (copy), Promise (copy), PasskeyConstants (copy)
	local t1 = {
		postBody = HttpService:JSONEncode({
			isSilentUpgrade = p8
		})
	}
	local v24 = string.format("%sv1/passkey/StartRegistration", Url.AUTH_URL)

	return p6((if not p7 then v24 else string.format("%s?flow=%s", v24, p7)), "POST", t1, p8):andThen(function(p9) -- line: 57
		-- upvalues: Promise (copy)
		return Promise.resolve(p9[1])
	end, function(p10) -- line: 60
		-- upvalues: HttpService (copy), Promise (copy), PasskeyConstants (copy)
		local v33 = if type(p10) ~= "table" then nil else HttpService:JSONEncode(p10)

		return Promise.reject({
			body = v33,
			name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME,
			source = PasskeyConstants.START_STEP
		})
	end)
end
local function attemptPasskeyRegistration(p11, p12, p13) -- line: 72
	-- upvalues: startPasskeyRegistration (copy), HttpService (copy), UserInputService (copy), Base64 (copy), default (copy), Promise (copy), PasskeyConstants (copy), Logger (copy), finishPasskeyRegistration (copy)
	return startPasskeyRegistration(p11, p12, p13):andThen(function(p14) -- line: 73
		-- upvalues: HttpService (copy), p13 (copy), UserInputService (copy), Base64 (copy), default (copy), Promise (copy), PasskeyConstants (copy), Logger (copy), finishPasskeyRegistration (copy), p11 (copy)
		local data = HttpService:JSONDecode(p14.creationOptions)
		local sessionId = p14.sessionId
		local num = tonumber(data.publicKey.timeout)

		data.keyType = "platform"
		data.deviceBoundOnly = true
		data.isSilentPasskeyUpgrade = p13

		if UserInputService:GetPlatform() ~= Enum.Platform.Android then
			data.publicKey.challenge = Base64.FromUrlSafeBase64(data.publicKey.challenge)
			data.publicKey.user.id = Base64.FromUrlSafeBase64(data.publicKey.user.id)
		end

		local json = HttpService:JSONEncode(data)

		return default:registerCredentials(default.CredentialsTypes.FIDO2, json, num / 1000):andThen(function(p15) -- line: 92
			-- upvalues: HttpService (copy), Promise (copy), PasskeyConstants (copy), Logger (copy), Base64 (copy), sessionId (copy), finishPasskeyRegistration (copy), p11 (copy)
			local data2 = HttpService:JSONDecode(p15)

			if data2 == nil or next(data2) == nil then
				return Promise.reject({
					body = "Null resultTable",
					name = PasskeyConstants.USER_OS_DIALOG_ERROR_NAME,
					source = PasskeyConstants.CREDENTIALS_PROTOCOL_REGISTER_CREDENTIALS_EMPTY_RESPONSE
				})
			end

			if data2.errorCode ~= nil then
				Logger:warning("Passkey credential signing failed. Error {} ({}) returned.", data2.errorCode, data2.errorMsg)

				return Promise.reject({
					body = data2.errorMsg,
					name = PasskeyConstants.USER_OS_DIALOG_ERROR_NAME,
					source = PasskeyConstants.CREDENTIALS_PROTOCOL_REGISTER_CREDENTIALS_ERROR_CODE
				})
			end

			data2.id = Base64.ToUrlSafeBase64(data2.id)
			data2.rawId = Base64.ToUrlSafeBase64(data2.rawId)
			data2.response.attestationObject = Base64.ToUrlSafeBase64(data2.response.attestationObject)
			data2.response.clientDataJSON = Base64.ToUrlSafeBase64(data2.response.clientDataJSON)

			local json2 = HttpService:JSONEncode(data2)
			local t2 = {
				credentialNickname = "Passkey",
				sessionId = sessionId,
				attestationResponse = json2
			}
			local json3 = HttpService:JSONEncode(t2)

			return finishPasskeyRegistration(p11, json3)
		end, function(p16) -- line: 127
			-- upvalues: Promise (copy), PasskeyConstants (copy)
			return Promise.reject({
				body = p16,
				name = PasskeyConstants.USER_OS_DIALOG_ERROR_NAME,
				source = PasskeyConstants.CREDENTIALS_PROTOCOL_REGISTER_CREDENTIALS_OTHER_ERR
			})
		end)
	end, function(p17) -- line: 134
		-- upvalues: Promise (copy), PasskeyConstants (copy)
		if type(p17) == "table" and p17.name then
			return Promise.reject(p17)
		end

		return Promise.reject({
			body = p17,
			name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME,
			source = PasskeyConstants.UNKNOWN_BACKEND_ERROR
		})
	end)
end

return attemptPasskeyRegistration
