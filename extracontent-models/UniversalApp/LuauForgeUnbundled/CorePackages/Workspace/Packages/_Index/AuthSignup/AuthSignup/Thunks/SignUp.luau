local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Promise")

local SignUpRequests = require("@game/CorePackages/Workspace/Packages/_Index/AuthSignup/AuthSignup/Requests/SignUpRequests")
local SignUpV2ErrorCodes = require("@game/CorePackages/Workspace/Packages/_Index/AuthSignup/AuthSignup/Enums/SignUpV2ErrorCodes")
local AppSignupCounterNames = require("@game/CorePackages/Workspace/Packages/_Index/AuthSignup/AuthSignup/Enums/AppSignupCounterNames")

local notificationType = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/RobloxAppEnums").NotificationType

local AuthCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/AuthCommon")
local authMemStorageKeys = AuthCommon.Enums.AuthMemStorageKeys
local reportEphemeralCounter = AuthCommon.Analytics.reportEphemeralCounter
local shouldSkipLegacyPasswordSaveEvent = AuthCommon.Utils.shouldSkipLegacyPasswordSaveEvent

local statusCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Http").StatusCodes

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Loggers").Logger
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/SharedFlags")
local fFlagDisableMemStorageServicePasswordEvent = SharedFlags.FFlagDisableMemStorageServicePasswordEvent
local fFlagLuaAppSkipDuplicateIosPasswordSavePrompt = SharedFlags.FFlagLuaAppSkipDuplicateIosPasswordSavePrompt

local CredentialsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/CredentialsProtocol")
local constants = CredentialsProtocol.Constants
local default = CredentialsProtocol.CredentialsProtocol.default

local function signUpRequest(p2, p3)
	return SignUpRequests.signUpV2(p2, p3, {})
end

return function(p2, p3, object, p4, p5, p6, p7, p8, p9)
	return SignUpRequests.signUpV2(p2, p6, {}):andThen(function(p10)
		object:BroadcastNotification("", notificationType.DID_SIGN_UP)

		reportEphemeralCounter(AppSignupCounterNames.Success, 1)

		local v5 = p6.username and p6.password and string.len(p6.password) > 0

		local v6 = fFlagLuaAppSkipDuplicateIosPasswordSavePrompt

		if v6 then
			local v8 = p7 == true and v5 == true
			v6 = shouldSkipLegacyPasswordSaveEvent(v8)
		end

		if not fFlagDisableMemStorageServicePasswordEvent and v5 and not v6 then
			MemStorageService:Fire(
				authMemStorageKeys.AuthenticatedCredentials,
				HttpService:JSONEncode({
					cvalue = p6.username,
					password = p6.password,
					authType = "signup"
				})
			)
		end

		if p7 and p6.password and #p6.password > 0 then
			local jsonEncode = HttpService:JSONEncode({
				username = p6.username,
				password = p6.password
			})

			default:registerCredentials(
				default.CredentialsTypes.password,
				jsonEncode,
				constants.Defaults.PASSWORD_REGISTRATION_CREDENTIALSPROTOCOL_TIMEOUT
			):andThen(
				function(json)
					local v8 = not json and {} or HttpService:JSONDecode(json)

					if v8 and v8.errorCode == nil then
						logger:info("Successfully registered password.")
					else
						logger:warning("Error registering password: " .. tostring(v8.errorMsg))
					end
				end,
				function(p11)
					logger:warning("Error registering password: " .. tostring(p11))
				end
			):await()
		end

		return Promise.resolve(p10)
	end, function(data)
		local success, result = pcall(function()
			return HttpService:JSONDecode(data.Body)
		end)

		if not success then
			return Promise.reject()
		end

		local code = result.errors and result.errors[1] and result.errors[1].code

		reportEphemeralCounter(AppSignupCounterNames.Failure, 1)

		if code == SignUpV2ErrorCodes.Captcha then
			reportEphemeralCounter(AppSignupCounterNames.FailureCaptcha, 1)
		elseif code == SignUpV2ErrorCodes.TooManyAttempts then
			reportEphemeralCounter(AppSignupCounterNames.FailureThrottled, 1)
		elseif code == SignUpV2ErrorCodes.InvalidBirthdate then
			reportEphemeralCounter(AppSignupCounterNames.FailureBirthdayInvalid, 1)
		elseif code == SignUpV2ErrorCodes.InvalidUsername then
			reportEphemeralCounter(AppSignupCounterNames.FailureUsernameInvalid, 1)
		elseif code == SignUpV2ErrorCodes.UsernameAlreadyTaken then
			reportEphemeralCounter(AppSignupCounterNames.FailureUsernameTaken, 1)
		elseif code == SignUpV2ErrorCodes.InvalidPassword then
			reportEphemeralCounter(AppSignupCounterNames.FailurePasswordInvalid, 1)
		elseif code == SignUpV2ErrorCodes.UsernameAndPasswordTheSame then
			reportEphemeralCounter(AppSignupCounterNames.FailurePasswordMatchesUsername, 1)
		elseif code == SignUpV2ErrorCodes.UnavailableInRegion then
			reportEphemeralCounter(AppSignupCounterNames.FailureUnavailableInRegion, 1)
		elseif code == SignUpV2ErrorCodes.PasswordTooSimple then
			reportEphemeralCounter(AppSignupCounterNames.FailurePasswordTooSimple, 1)
		elseif data.HttpError == Enum.HttpError.OK and data.StatusCode == statusCodes.TOO_MANY_REQUESTS then
			reportEphemeralCounter(AppSignupCounterNames.FailureThrottled, 1)
		elseif
			data.HttpError == Enum.HttpError.OK
			and data.StatusCode == statusCodes.INTERNAL_SERVER_ERROR
		then
			reportEphemeralCounter(AppSignupCounterNames.FailureInternalServerError, 1)
		elseif data.HttpError == Enum.HttpError.OK and data.StatusCode == statusCodes.BAD_REQUEST then
			reportEphemeralCounter(AppSignupCounterNames.FailureBadRequest, 1)
		elseif data.HttpError == Enum.HttpError.OK and data.StatusCode == statusCodes.NOT_FOUND then
			reportEphemeralCounter(AppSignupCounterNames.FailureNotFound, 1)
		else
			reportEphemeralCounter(AppSignupCounterNames.FailureUnknownError, 1)
		end

		return Promise.reject(code)
	end)
end
