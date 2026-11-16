local AuthSignup = script:FindFirstAncestor("AuthSignup")
local parent = AuthSignup.Parent

local HttpService = game:GetService("HttpService")
local MemStorageService = game:GetService("MemStorageService")

local Promise = require(parent.Promise)

local SignUpRequests = require(AuthSignup.Requests.SignUpRequests)
local SignUpV2ErrorCodes = require(AuthSignup.Enums.SignUpV2ErrorCodes)
local AppSignupCounterNames = require(AuthSignup.Enums.AppSignupCounterNames)

local RobloxAppEnums = require(parent.RobloxAppEnums)
local NotificationType = RobloxAppEnums.NotificationType

local AuthCommon = require(parent.AuthCommon)
local AuthMemStorageKeys = AuthCommon.Enums.AuthMemStorageKeys
local reportEphemeralCounter = AuthCommon.Analytics.reportEphemeralCounter
local shouldSkipLegacyPasswordSaveEvent = AuthCommon.Utils.shouldSkipLegacyPasswordSaveEvent

local Http = require(parent.Http)
local StatusCodes = Http.StatusCodes

local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger
local SharedFlags = require(parent.SharedFlags)
local FFlagDisableMemStorageServicePasswordEvent = SharedFlags.FFlagDisableMemStorageServicePasswordEvent
local FFlagLuaAppSkipDuplicateIosPasswordSavePrompt = SharedFlags.FFlagLuaAppSkipDuplicateIosPasswordSavePrompt

local CredentialsProtocol = require(parent.CredentialsProtocol)
local Constants = CredentialsProtocol.Constants
local default = CredentialsProtocol.CredentialsProtocol.default

local function signUpRequest(p, p2) -- 1 equivalent call inferred from this helper
	return SignUpRequests.signUpV2(p, p2, {})
end

return function(p, _, object, _, _, p2, p3, _, _)
	return signUpRequest(p, p2):andThen(function(p4) -- inferred equivalent call
		object:BroadcastNotification("", NotificationType.DID_SIGN_UP)

		reportEphemeralCounter(AppSignupCounterNames.Success, 1)

		local v = p2.username and p2.password and string.len(p2.password) > 0

		local v2 = FFlagLuaAppSkipDuplicateIosPasswordSavePrompt

		if v2 then
			local v3

			if p3 == true then
				v3 = v == true
			else
				v3 = false
			end

			v2 = shouldSkipLegacyPasswordSaveEvent(v3)
		end

		if not FFlagDisableMemStorageServicePasswordEvent and v and not v2 then
			MemStorageService:Fire(
				AuthMemStorageKeys.AuthenticatedCredentials,
				HttpService:JSONEncode({
					cvalue = p2.username,
					password = p2.password,
					authType = "signup"
				})
			)
		end

		if p3 and p2.password and #p2.password > 0 then
			local jsonEncode = HttpService:JSONEncode({
				username = p2.username,
				password = p2.password
			})

			default:registerCredentials(
				default.CredentialsTypes.password,
				jsonEncode,
				Constants.Defaults.PASSWORD_REGISTRATION_CREDENTIALSPROTOCOL_TIMEOUT
			):andThen(
				function(json)
					local v3 = not json and {} or HttpService:JSONDecode(json)

					if v3 and v3.errorCode == nil then
						Logger:info("Successfully registered password.")
					else
						Logger:warning("Error registering password: " .. tostring(v3.errorMsg))
					end
				end,
				function(p5)
					Logger:warning("Error registering password: " .. tostring(p5))
				end
			):await()
		end

		return Promise.resolve(p4)
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
		elseif data.HttpError == Enum.HttpError.OK and data.StatusCode == StatusCodes.TOO_MANY_REQUESTS then
			reportEphemeralCounter(AppSignupCounterNames.FailureThrottled, 1)
		elseif data.HttpError == Enum.HttpError.OK and data.StatusCode == StatusCodes.INTERNAL_SERVER_ERROR then
			reportEphemeralCounter(AppSignupCounterNames.FailureInternalServerError, 1)
		elseif data.HttpError == Enum.HttpError.OK and data.StatusCode == StatusCodes.BAD_REQUEST then
			reportEphemeralCounter(AppSignupCounterNames.FailureBadRequest, 1)
		elseif data.HttpError == Enum.HttpError.OK and data.StatusCode == StatusCodes.NOT_FOUND then
			reportEphemeralCounter(AppSignupCounterNames.FailureNotFound, 1)
		else
			reportEphemeralCounter(AppSignupCounterNames.FailureUnknownError, 1)
		end

		return Promise.reject(code)
	end)
end
