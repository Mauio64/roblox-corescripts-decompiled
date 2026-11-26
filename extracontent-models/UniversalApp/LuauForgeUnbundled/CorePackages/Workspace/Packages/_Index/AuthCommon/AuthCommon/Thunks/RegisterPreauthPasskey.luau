local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local Base64 = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/Base64")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Url
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/CredentialsProtocol").CredentialsProtocol.default
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Loggers").Logger

local PasskeyConstants = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Common/PasskeyConstants")

local function getStartPreauthRegistrationUrl()
	return string.format("%sv1/passkey/start-preauth-registration", url.AUTH_URL)
end

local function startPreauthPasskeyRegistration(callback, p2)
	local jsonEncode = HttpService:JSONEncode({ username = p2 })
	return callback(string.format("%sv1/passkey/start-preauth-registration", url.AUTH_URL), "POST", {
		postBody = jsonEncode
	}):andThen(
		function(list)
			return Promise.resolve(list[1])
		end,
		function(p3)
			local v5 = if type(p3) == "table" then HttpService:JSONEncode(p3) else nil

			return Promise.reject({
				body = v5,
				name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME,
				source = PasskeyConstants.START_STEP
			})
		end
	)
end

local function attemptPreauthPasskeyRegistration(p2, p3)
	return startPreauthPasskeyRegistration(p2, p3):andThen(function(p4)
		local jsonDecode = HttpService:JSONDecode(p4.creationOptions)
		local timeout = tonumber(jsonDecode.publicKey.timeout)
		jsonDecode.keyType = PasskeyConstants.PLATFORM
		jsonDecode.deviceBoundOnly = true

		if UserInputService:GetPlatform() ~= Enum.Platform.Android then
			jsonDecode.publicKey.challenge = Base64.FromUrlSafeBase64(jsonDecode.publicKey.challenge)
			jsonDecode.publicKey.user.id = Base64.FromUrlSafeBase64(jsonDecode.publicKey.user.id)
		end

		local jsonEncode = HttpService:JSONEncode(jsonDecode)
		return default:registerCredentials(
			default.CredentialsTypes.FIDO2,
			jsonEncode,
			timeout / PasskeyConstants.PASSKEY_TIMEOUT_DURATION
		):andThen(
			function(json)
				local jsonDecode2 = HttpService:JSONDecode(json)

				if jsonDecode2 == nil or next(jsonDecode2) == nil then
					return Promise.reject({
						body = "Null resultTable",
						name = PasskeyConstants.USER_OS_DIALOG_ERROR_NAME,
						source = PasskeyConstants.CREDENTIALS_PROTOCOL_REGISTER_CREDENTIALS_EMPTY_RESPONSE
					})
				end

				if jsonDecode2.errorCode ~= nil then
					logger:warning(
						"Passkey credential signing failed. Error {} ({}) returned.",
						jsonDecode2.errorCode,
						jsonDecode2.errorMsg
					)

					return Promise.reject({
						body = jsonDecode2.errorMsg,
						name = PasskeyConstants.USER_OS_DIALOG_ERROR_NAME,
						source = PasskeyConstants.CREDENTIALS_PROTOCOL_REGISTER_CREDENTIALS_ERROR_CODE
					})
				end

				jsonDecode2.id = Base64.ToUrlSafeBase64(jsonDecode2.id)
				jsonDecode2.rawId = Base64.ToUrlSafeBase64(jsonDecode2.rawId)
				jsonDecode2.response.attestationObject = Base64.ToUrlSafeBase64(jsonDecode2.response.attestationObject)
				jsonDecode2.response.clientDataJSON = Base64.ToUrlSafeBase64(jsonDecode2.response.clientDataJSON)

				local jsonEncode2 = HttpService:JSONEncode(jsonDecode2)
				return Promise.resolve({
					result = jsonEncode2,
					sessionId = p4.sessionId
				})
			end,
			function(p5)
				return Promise.reject({
					body = p5,
					name = PasskeyConstants.USER_OS_DIALOG_ERROR_NAME,
					source = PasskeyConstants.CREDENTIALS_PROTOCOL_REGISTER_CREDENTIALS_OTHER_ERR
				})
			end
		)
	end, function(p4)
		if type(p4) == "table" and p4.name then
			return Promise.reject(p4)
		end

		return Promise.reject({
			body = p4,
			name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME,
			source = PasskeyConstants.UNKNOWN_BACKEND_ERROR
		})
	end)
end

return attemptPreauthPasskeyRegistration
