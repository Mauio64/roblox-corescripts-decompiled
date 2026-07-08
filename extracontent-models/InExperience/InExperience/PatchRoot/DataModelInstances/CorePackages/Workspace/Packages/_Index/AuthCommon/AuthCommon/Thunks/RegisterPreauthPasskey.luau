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

local function getStartPreauthRegistrationUrl() -- line: 18
	-- upvalues: Url (copy)
	return string.format("%sv1/passkey/start-preauth-registration", Url.AUTH_URL)
end
local function startPreauthPasskeyRegistration(p1, p2) -- line: 22
	-- upvalues: HttpService (copy), Url (copy), Promise (copy), PasskeyConstants (copy)
	local json = HttpService:JSONEncode({
		username = p2
	})

	return p1(string.format("%sv1/passkey/start-preauth-registration", Url.AUTH_URL), "POST", {
		postBody = json
	}):andThen(function(p3) -- line: 27
		-- upvalues: Promise (copy)
		return Promise.resolve(p3[1])
	end, function(p4) -- line: 29
		-- upvalues: HttpService (copy), Promise (copy), PasskeyConstants (copy)
		local v21 = if type(p4) ~= "table" then nil else HttpService:JSONEncode(p4)

		return Promise.reject({
			body = v21,
			name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME,
			source = PasskeyConstants.START_STEP
		})
	end)
end
local function attemptPreauthPasskeyRegistration(p5, p6) -- line: 40
	-- upvalues: startPreauthPasskeyRegistration (copy), HttpService (copy), PasskeyConstants (copy), UserInputService (copy), Base64 (copy), default (copy), Promise (copy), Logger (copy)
	return startPreauthPasskeyRegistration(p5, p6):andThen(function(p7) -- line: 41
		-- upvalues: HttpService (copy), PasskeyConstants (copy), UserInputService (copy), Base64 (copy), default (copy), Promise (copy), Logger (copy)
		local data = HttpService:JSONDecode(p7.creationOptions)
		local num = tonumber(data.publicKey.timeout)

		data.keyType = PasskeyConstants.PLATFORM
		data.deviceBoundOnly = true

		if UserInputService:GetPlatform() ~= Enum.Platform.Android then
			data.publicKey.challenge = Base64.FromUrlSafeBase64(data.publicKey.challenge)
			data.publicKey.user.id = Base64.FromUrlSafeBase64(data.publicKey.user.id)
		end

		local json = HttpService:JSONEncode(data)

		return default:registerCredentials(default.CredentialsTypes.FIDO2, json, num / PasskeyConstants.PASSKEY_TIMEOUT_DURATION):andThen(function(p8) -- line: 60
			-- upvalues: HttpService (copy), Promise (copy), PasskeyConstants (copy), Logger (copy), Base64 (copy), p7 (copy)
			local data2 = HttpService:JSONDecode(p8)

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

			return Promise.resolve({
				result = json2,
				sessionId = p7.sessionId
			})
		end, function(p9) -- line: 88
			-- upvalues: Promise (copy), PasskeyConstants (copy)
			return Promise.reject({
				body = p9,
				name = PasskeyConstants.USER_OS_DIALOG_ERROR_NAME,
				source = PasskeyConstants.CREDENTIALS_PROTOCOL_REGISTER_CREDENTIALS_OTHER_ERR
			})
		end)
	end, function(p10) -- line: 95
		-- upvalues: Promise (copy), PasskeyConstants (copy)
		if type(p10) == "table" and p10.name then
			return Promise.reject(p10)
		end

		return Promise.reject({
			body = p10,
			name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME,
			source = PasskeyConstants.UNKNOWN_BACKEND_ERROR
		})
	end)
end

return attemptPreauthPasskeyRegistration
