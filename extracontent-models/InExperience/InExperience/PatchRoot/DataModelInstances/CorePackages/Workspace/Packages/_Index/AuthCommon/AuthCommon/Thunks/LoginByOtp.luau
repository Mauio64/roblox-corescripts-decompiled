local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local HttpService = game:GetService("HttpService")

local Promise = require(parent.Promise)
local LoginRequests = require(AuthCommon.Http.Requests.LoginRequests)
local LoginResult = require(AuthCommon.Models.LoginResult)
local LoginErrorCodes = require(AuthCommon.Enums.LoginErrorCodes)
local LoginMethods = require(AuthCommon.Enums.LoginMethods)
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local GetMultipleUsersPerCredentialErrorData = require(AuthCommon.Utils.GetMultipleUsersPerCredentialErrorData)
local GetLoginByCredentialSsoErrorMessage = require(AuthCommon.Utils.GetLoginByCredentialSsoErrorMessage)
local LoginByOtpSSOErrorsTelemetry = require(AuthCommon.Utils.LoginByOtpSSOErrorsTelemetry)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin = SharedFlags.GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagEnableLoginAccountSelector = SharedFlags2.GetFFlagEnableLoginAccountSelector
local SharedFlags3 = require(parent.SharedFlags)
local GetFFlagEnableGenericTwoFAMessage = SharedFlags3.GetFFlagEnableGenericTwoFAMessage
local SharedFlags4 = require(parent.SharedFlags)
local FFlagEnableLastLoginMethodTracking = SharedFlags4.FFlagEnableLastLoginMethodTracking
local LoggingProtocol = require(parent.LoggingProtocol)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies
local FFlagEnableEmailOtpSsoConnect = require(AuthCommon.Flags.FFlagEnableEmailOtpSsoConnect)

local defineFastFlag = game:DefineFastFlag("EnableIllegalChildAccountLinkingErrorMessageOnLoginByOtp", false)

local function loginRequest(p, p2, p3, p4, p5) -- 1 equivalent call inferred from this helper
	if FFlagEnableEmailOtpSsoConnect and getAppFeaturePolicies().getUseSingleSignOn() then
		return LoginRequests.singleSignOnConnectWithCredential(p, p2, p3, "EmailOtpSessionToken")
	end

	return LoginRequests.logByOtp(p, p2, p3, p4, p5)
end

local function loginByOtp(p, p2, p3, securityQuestionsCallback, p4, p5)
	return function()
		local v = FFlagEnableEmailOtpSsoConnect and getAppFeaturePolicies().getUseSingleSignOn()
		return loginRequest(p, p2, p3, p4, p5):andThen(function(list) -- inferred equivalent call
			assert(list, "no login attempt result")
			assert(#list == 1, "no result or more than one result")
			local v2 = LoginResult.fromJsonData(list[1])
			assert(v2, "result invalid")

			if v then
				local appFeaturePolicies = getAppFeaturePolicies()

				if
					not (appFeaturePolicies.getLinkedAuthEndpointsEnabled() and appFeaturePolicies.getWebViewSupport())
					and LoginResult.hasTwoStepData(v2)
				then
					return Promise.reject({
						errorCode = LoginErrorCodes.ServiceUnavailable,
						errorKey = GetFFlagEnableGenericTwoFAMessage() and "Authentication.Login.Response.Require2FAGeneric" or "Authentication.Login.Response.Require2FA"
					})
				end
			end

			if FFlagEnableLastLoginMethodTracking then
				AppStorageUtilities.setLastSuccessfulSignInMethod(LoginMethods.EmailOtp)
			end

			return v2
		end, function(p6)
			local jsonDecode = HttpService:JSONDecode(p6.Body)
			local errorKey = nil
			local code = jsonDecode.errors[1].code
			local securityQuestionsData = nil
			local userFacingMessage = jsonDecode
				and jsonDecode.errors
				and jsonDecode.errors[1]
				and jsonDecode.errors[1].userFacingMessage

			if v then
				warn("Login ErrorCode:", code)
				local message = GetLoginByCredentialSsoErrorMessage.getMessage(
					code,
					"Authentication.Login.Response.IncorrectOtpCode",
					"Authentication.Login.Response.UnknownErrorLoginWithDifferentMethod"
				)
				local msgShown

				if type(message) == "table" then
					msgShown = message[1]
				else
					msgShown = message
				end

				LoggingProtocol.default:logRobloxTelemetryEvent(LoginByOtpSSOErrorsTelemetry, nil, {
					ssoErrorCode = code,
					msgShown = msgShown
				})

				return Promise.reject({
					errorKey = message,
					errorCode = GetLoginByCredentialSsoErrorMessage.getUiErrorCode(code),
					securityQuestionsCallback = securityQuestionsCallback,
					userFacingMessage = userFacingMessage
				})
			end

			if code == LoginErrorCodes.IncorrectCValueOrPassword then
				errorKey = "Authentication.Login.Response.IncorrectOtpCode"
				return Promise.reject({
					errorKey = errorKey,
					errorCode = code,
					securityQuestionsData = securityQuestionsData,
					securityQuestionsCallback = securityQuestionsCallback,
					userFacingMessage = userFacingMessage
				})
			end

			if GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and code == LoginErrorCodes.SecurityQuestions then
				errorKey = "Authentication.Login.Response.SomethingWentWrong"

				if jsonDecode.errors[1].fieldData then
					local jsonDecode2 = HttpService:JSONDecode(jsonDecode.errors[1].fieldData)

					if jsonDecode2.sessionId and jsonDecode2.userId then
						securityQuestionsData = jsonDecode2
						errorKey = nil
					end
				end
			else
				if GetFFlagEnableLoginAccountSelector() and code == LoginErrorCodes.MultipleUsersPerCredential then
					local usersData = GetMultipleUsersPerCredentialErrorData(jsonDecode)
					return Promise.reject({
						errorKey = errorKey,
						errorCode = code,
						usersData = usersData
					})
				end

				if code == LoginErrorCodes.ServiceUnavailable then
					errorKey = "Authentication.Login.Response.ServiceUnavailable"
				elseif defineFastFlag and code == LoginErrorCodes.IllegalChildAccountLinking then
					errorKey = "Authentication.Login.LinkIllegalChildAccountLinking"
				elseif code ~= LoginErrorCodes.AccountLocked then
					errorKey = "Authentication.Login.Response.UnknownErrorLoginWithDifferentMethod"
				end
			end

			return Promise.reject({
				errorKey = errorKey,
				errorCode = code,
				securityQuestionsData = securityQuestionsData,
				securityQuestionsCallback = securityQuestionsCallback,
				userFacingMessage = userFacingMessage
			})
		end)
	end
end

return loginByOtp
