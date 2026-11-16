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

local function getStartPreauthRegistrationUrl() -- 1 equivalent call inferred from this helper
	return string.format("%sv1/passkey/start-preauth-registration", Url.AUTH_URL)
end

local function startPreauthPasskeyRegistration(callback, username)
	local jsonEncode = HttpService:JSONEncode({ username = username })

	return callback(getStartPreauthRegistrationUrl(), "POST", { postBody = jsonEncode }):andThen(function(list) -- inferred equivalent call
		return Promise.resolve(list[1])
	end, function(p)
		local body

		if type(p) == "table" then
			body = HttpService:JSONEncode(p)
		end

		return Promise.reject({
			body = body,
			name = PasskeyConstants.BACKEND_CREATION_ERROR_NAME,
			source = PasskeyConstants.START_STEP
		})
	end)
end

local function attemptPreauthPasskeyRegistration(p, username)
	return startPreauthPasskeyRegistration(p, username):andThen(function(p2)
		local jsonDecode = HttpService:JSONDecode(p2.creationOptions)
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

				local jsonEncode2 = HttpService:JSONEncode(jsonDecode2)
				return Promise.resolve({ result = jsonEncode2, sessionId = p2.sessionId })
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

return attemptPreauthPasskeyRegistration
