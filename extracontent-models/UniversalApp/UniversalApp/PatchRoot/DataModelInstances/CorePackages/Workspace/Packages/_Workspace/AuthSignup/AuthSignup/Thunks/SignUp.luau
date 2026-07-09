local AuthSignup = script:FindFirstAncestor("AuthSignup")
local AuthSignupParent = AuthSignup.Parent
local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")
local Promise = require(AuthSignupParent.Promise)
local SignUpRequests = require(AuthSignup.Requests.SignUpRequests)
local SignUpV2ErrorCodes = require(AuthSignup.Enums.SignUpV2ErrorCodes)
local AppSignupCounterNames = require(AuthSignup.Enums.AppSignupCounterNames)
local NotificationType = require(AuthSignupParent.RobloxAppEnums).NotificationType
local AuthCommon = require(AuthSignupParent.AuthCommon)
local AuthMemStorageKeys = AuthCommon.Enums.AuthMemStorageKeys
local reportEphemeralCounter = AuthCommon.Analytics.reportEphemeralCounter
local StatusCodes = require(AuthSignupParent.Http).StatusCodes
local Logger = require(AuthSignupParent.Loggers).Logger
local FFlagDisableMemStorageServicePasswordEvent = require(AuthSignupParent.SharedFlags).FFlagDisableMemStorageServicePasswordEvent
local CredentialsProtocol = require(AuthSignupParent.CredentialsProtocol)
local Constants = CredentialsProtocol.Constants
local default = CredentialsProtocol.CredentialsProtocol.default

local function signUpRequest(p1, p2) -- line: 30
	-- upvalues: SignUpRequests (copy)
	return SignUpRequests.signUpV2(p1, p2, {})
end

return function(p3, _, p5, _, _, p8, p9, _, _) -- line: 35
	-- upvalues: SignUpRequests (copy), NotificationType (copy), reportEphemeralCounter (copy), AppSignupCounterNames (copy), FFlagDisableMemStorageServicePasswordEvent (copy), MemStorageService (copy), AuthMemStorageKeys (copy), HttpService (copy), default (copy), Constants (copy), Logger (copy), Promise (copy), SignUpV2ErrorCodes (copy), StatusCodes (copy)
	return SignUpRequests.signUpV2(p3, p8, {}):andThen(function(p12) -- line: 46
		-- upvalues: p5 (copy), NotificationType (copy), reportEphemeralCounter (copy), AppSignupCounterNames (copy), p8 (copy), FFlagDisableMemStorageServicePasswordEvent (copy), MemStorageService (copy), AuthMemStorageKeys (copy), HttpService (copy), p9 (copy), default (copy), Constants (copy), Logger (copy), Promise (copy)
		p5:BroadcastNotification("", NotificationType.DID_SIGN_UP)
		reportEphemeralCounter(AppSignupCounterNames.Success, 1)

		local v32 = p8.username and (p8.password and string.len(p8.password) > 0)

		if not FFlagDisableMemStorageServicePasswordEvent and v32 then
			MemStorageService:Fire(AuthMemStorageKeys.AuthenticatedCredentials, HttpService:JSONEncode({
				authType = "signup",
				cvalue = p8.username,
				password = p8.password
			}))
		end

		if p9 and p8.password and #p8.password > 0 then
			local t1 = {
				username = p8.username,
				password = p8.password
			}
			local json = HttpService:JSONEncode(t1)

			default:registerCredentials(default.CredentialsTypes.password, json, Constants.Defaults.PASSWORD_REGISTRATION_CREDENTIALSPROTOCOL_TIMEOUT):andThen(function(p13) -- line: 79
				-- upvalues: HttpService (copy), Logger (copy)
				local v40 = if not p13 then {} else HttpService:JSONDecode(p13)

				if v40 and v40.errorCode == nil then
					Logger:info("Successfully registered password.")

					return
				end

				Logger:warning("Error registering password: " .. tostring(v40.errorMsg))
			end, function(p14) -- line: 87
				-- upvalues: Logger (copy)
				Logger:warning("Error registering password: " .. tostring(p14))
			end):await()
		end

		return Promise.resolve(p12)
	end, function(p15) -- line: 94
		-- upvalues: HttpService (copy), reportEphemeralCounter (copy), AppSignupCounterNames (copy), SignUpV2ErrorCodes (copy), StatusCodes (copy), Promise (copy)
		local ok, result = pcall(function() -- line: 95
			-- upvalues: HttpService (copy), p15 (copy)
			return HttpService:JSONDecode(p15.Body)
		end)

		if ok then
			local v38 = result.errors and (result.errors[1] and result.errors[1].code)

			reportEphemeralCounter(AppSignupCounterNames.Failure, 1)

			if v38 == SignUpV2ErrorCodes.Captcha then
				reportEphemeralCounter(AppSignupCounterNames.FailureCaptcha, 1)
			elseif v38 == SignUpV2ErrorCodes.TooManyAttempts then
				reportEphemeralCounter(AppSignupCounterNames.FailureThrottled, 1)
			elseif v38 == SignUpV2ErrorCodes.InvalidBirthdate then
				reportEphemeralCounter(AppSignupCounterNames.FailureBirthdayInvalid, 1)
			elseif v38 == SignUpV2ErrorCodes.InvalidUsername then
				reportEphemeralCounter(AppSignupCounterNames.FailureUsernameInvalid, 1)
			elseif v38 == SignUpV2ErrorCodes.UsernameAlreadyTaken then
				reportEphemeralCounter(AppSignupCounterNames.FailureUsernameTaken, 1)
			elseif v38 == SignUpV2ErrorCodes.InvalidPassword then
				reportEphemeralCounter(AppSignupCounterNames.FailurePasswordInvalid, 1)
			elseif v38 == SignUpV2ErrorCodes.UsernameAndPasswordTheSame then
				reportEphemeralCounter(AppSignupCounterNames.FailurePasswordMatchesUsername, 1)
			elseif v38 == SignUpV2ErrorCodes.UnavailableInRegion then
				reportEphemeralCounter(AppSignupCounterNames.FailureUnavailableInRegion, 1)
			elseif v38 == SignUpV2ErrorCodes.PasswordTooSimple then
				reportEphemeralCounter(AppSignupCounterNames.FailurePasswordTooSimple, 1)
			elseif p15.HttpError == Enum.HttpError.OK and p15.StatusCode == StatusCodes.TOO_MANY_REQUESTS then
				reportEphemeralCounter(AppSignupCounterNames.FailureThrottled, 1)
			elseif p15.HttpError == Enum.HttpError.OK and p15.StatusCode == StatusCodes.INTERNAL_SERVER_ERROR then
				reportEphemeralCounter(AppSignupCounterNames.FailureInternalServerError, 1)
			elseif p15.HttpError == Enum.HttpError.OK and p15.StatusCode == StatusCodes.BAD_REQUEST then
				reportEphemeralCounter(AppSignupCounterNames.FailureBadRequest, 1)
			elseif p15.HttpError == Enum.HttpError.OK and p15.StatusCode == StatusCodes.NOT_FOUND then
				reportEphemeralCounter(AppSignupCounterNames.FailureNotFound, 1)
			else
				reportEphemeralCounter(AppSignupCounterNames.FailureUnknownError, 1)
			end

			return Promise.reject(v38)
		end

		return Promise.reject()
	end)
end
