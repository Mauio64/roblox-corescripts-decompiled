local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local Base64 = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/Base64")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Url
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/CredentialsProtocol").CredentialsProtocol.default
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Loggers").Logger
local PasskeyConstants = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Common/PasskeyConstants")

local fFlagEmitPasskeyRegistrationSourceOnFinish = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEmitPasskeyRegistrationSourceOnFinish

local function getFinishRegistrationUrl()
	return string.format("%sv1/passkey/FinishRegistration", url.AUTH_URL)
end

local function finishPasskeyRegistration(callback, jsonEncode)
	return callback(string.format("%sv1/passkey/FinishRegistration", url.AUTH_URL), "POST", {
		postBody = jsonEncode
	}):andThen(
		function(p2)
			return Promise.resolve(p2)
		end,
		function(p2)
			local v5 = if type(p2) == "table" then HttpService:JSONEncode(p2) else nil

			return Promise.reject({
				body = v5,
				name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME,
				source = PasskeyConstants.FINISH_STEP
			})
		end
	)
end

local function getStartRegistrationUrl(p2)
	local v5 = string.format("%sv1/passkey/StartRegistration", url.AUTH_URL)

	if p2 then
		return string.format("%s?flow=%s", v5, p2)
	end

	return v5
end

local function startPasskeyRegistration(callback, p2, isSilentPasskeyUpgrade)
	local v5 = {
		postBody = HttpService:JSONEncode({ isSilentUpgrade = isSilentPasskeyUpgrade })
	}
	local v6 = string.format("%sv1/passkey/StartRegistration", url.AUTH_URL)

	if p2 then
		v6 = string.format("%s?flow=%s", v6, p2)
	end

	return callback(v6, "POST", v5, isSilentPasskeyUpgrade):andThen(function(list)
		return Promise.resolve(list[1])
	end, function(p3)
		local v7 = if type(p3) == "table" then HttpService:JSONEncode(p3) else nil

		return Promise.reject({
			body = v7,
			name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME,
			source = PasskeyConstants.START_STEP
		})
	end)
end

local function attemptPasskeyRegistration(p2, p3, isSilentPasskeyUpgrade, p4)
	return startPasskeyRegistration(p2, p3, isSilentPasskeyUpgrade):andThen(function(p5)
		local jsonDecode = HttpService:JSONDecode(p5.creationOptions)
		local sessionId = p5.sessionId
		local timeout = tonumber(jsonDecode.publicKey.timeout)
		jsonDecode.keyType = "platform"
		jsonDecode.deviceBoundOnly = true
		jsonDecode.isSilentPasskeyUpgrade = isSilentPasskeyUpgrade

		if UserInputService:GetPlatform() ~= Enum.Platform.Android then
			jsonDecode.publicKey.challenge = Base64.FromUrlSafeBase64(jsonDecode.publicKey.challenge)
			jsonDecode.publicKey.user.id = Base64.FromUrlSafeBase64(jsonDecode.publicKey.user.id)
		end

		local jsonEncode = HttpService:JSONEncode(jsonDecode)

		return default:registerCredentials(default.CredentialsTypes.FIDO2, jsonEncode, timeout / 1000):andThen(
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

				return finishPasskeyRegistration(p2, HttpService:JSONEncode({
					sessionId = sessionId,
					credentialNickname = "Passkey",
					attestationResponse = HttpService:JSONEncode(jsonDecode2),
					source = if fFlagEmitPasskeyRegistrationSourceOnFinish then p4 else nil
				}))
			end,
			function(p6)
				return Promise.reject({
					body = p6,
					name = PasskeyConstants.USER_OS_DIALOG_ERROR_NAME,
					source = PasskeyConstants.CREDENTIALS_PROTOCOL_REGISTER_CREDENTIALS_OTHER_ERR
				})
			end
		)
	end, function(p5)
		if type(p5) == "table" and p5.name then
			return Promise.reject(p5)
		end

		return Promise.reject({
			body = p5,
			name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME,
			source = PasskeyConstants.UNKNOWN_BACKEND_ERROR
		})
	end)
end

return attemptPasskeyRegistration
