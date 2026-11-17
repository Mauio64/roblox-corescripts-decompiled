local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local AuthCommon = script:FindFirstAncestor("AuthCommon")

local parent = AuthCommon.Parent
local Base64 = require(AuthCommon.Utils.Base64)
local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url
local CredentialsProtocol = require(parent.CredentialsProtocol)
local default = CredentialsProtocol.CredentialsProtocol.default
local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger
local PasskeyConstants = require(AuthCommon.Common.PasskeyConstants)

local SharedFlags = require(parent.SharedFlags)
local FFlagEmitPasskeyRegistrationSourceOnFinish = SharedFlags.FFlagEmitPasskeyRegistrationSourceOnFinish

local function getFinishRegistrationUrl() -- 1 equivalent call inferred from this helper
	return string.format("%sv1/passkey/FinishRegistration", Url.AUTH_URL)
end

local function finishPasskeyRegistration(callback, jsonEncode)
	return callback(getFinishRegistrationUrl(), "POST", { postBody = jsonEncode }):andThen(function(p) -- inferred equivalent call
		return Promise.resolve(p)
	end, function(p)
		local body

		if type(p) == "table" then
			body = HttpService:JSONEncode(p)
		end

		return Promise.reject({
			body = body,
			name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME,
			source = PasskeyConstants.FINISH_STEP
		})
	end)
end

local function getStartRegistrationUrl(p) -- 1 equivalent call inferred from this helper
	local v = string.format("%sv1/passkey/StartRegistration", Url.AUTH_URL)

	if p then
		return string.format("%s?flow=%s", v, p)
	end

	return v
end

local function startPasskeyRegistration(callback, p, isSilentPasskeyUpgrade)
	local v = {
		postBody = HttpService:JSONEncode({ isSilentUpgrade = isSilentPasskeyUpgrade })
	}

	return callback(getStartRegistrationUrl(p), "POST", v, isSilentPasskeyUpgrade):andThen(function(list) -- inferred equivalent call
		return Promise.resolve(list[1])
	end, function(p2)
		local body

		if type(p2) == "table" then
			body = HttpService:JSONEncode(p2)
		end

		return Promise.reject({
			body = body,
			name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME,
			source = PasskeyConstants.START_STEP
		})
	end)
end

local function attemptPasskeyRegistration(p, p2, isSilentPasskeyUpgrade, p3)
	return startPasskeyRegistration(p, p2, isSilentPasskeyUpgrade):andThen(function(p4)
		local jsonDecode = HttpService:JSONDecode(p4.creationOptions)
		local sessionId = p4.sessionId
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
					Logger:warning(
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

				local v = {
					sessionId = sessionId,
					credentialNickname = "Passkey",
					attestationResponse = HttpService:JSONEncode(jsonDecode2),
					source = nil
				}
				local source

				if FFlagEmitPasskeyRegistrationSourceOnFinish then
					source = p3
				end

				v.source = source

				return finishPasskeyRegistration(p, HttpService:JSONEncode(v))
			end,
			function(body)
				return Promise.reject({
					body = body,
					name = PasskeyConstants.USER_OS_DIALOG_ERROR_NAME,
					source = PasskeyConstants.CREDENTIALS_PROTOCOL_REGISTER_CREDENTIALS_OTHER_ERR
				})
			end
		)
	end, function(body)
		if type(body) == "table" and body.name then
			return Promise.reject(body)
		end

		return Promise.reject({
			body = body,
			name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME,
			source = PasskeyConstants.UNKNOWN_BACKEND_ERROR
		})
	end)
end

return attemptPasskeyRegistration
