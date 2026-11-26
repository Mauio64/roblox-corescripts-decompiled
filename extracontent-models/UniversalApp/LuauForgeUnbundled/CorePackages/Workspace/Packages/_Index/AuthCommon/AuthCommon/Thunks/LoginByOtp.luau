local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local LoginRequests = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/LoginRequests")
local LoginResult = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Models/LoginResult")
local LoginErrorCodes = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginErrorCodes")
local LoginMethods = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginMethods")
local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")
local GetMultipleUsersPerCredentialErrorData = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/GetMultipleUsersPerCredentialErrorData")
local GetLoginByCredentialSsoErrorMessage = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/GetLoginByCredentialSsoErrorMessage")
local LoginByOtpSSOErrorsTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/LoginByOtpSSOErrorsTelemetry")

local getFFlagLuaAppUsingSecurityQuestionsForLuaLogin = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin
local getFFlagEnableLoginAccountSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagEnableLoginAccountSelector
local getFFlagEnableGenericTwoFAMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagEnableGenericTwoFAMessage
local fFlagEnableLastLoginMethodTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEnableLastLoginMethodTracking
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/LoggingProtocol")
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UniversalAppPolicy").getAppFeaturePolicies
local FFlagEnableEmailOtpSsoConnect = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Flags/FFlagEnableEmailOtpSsoConnect")

local defineFastFlag = game:DefineFastFlag(
	"EnableIllegalChildAccountLinkingErrorMessageOnLoginByOtp",
	false
)

local function loginRequest(p2, p3, p4, p5, p6)
	if FFlagEnableEmailOtpSsoConnect and getAppFeaturePolicies().getUseSingleSignOn() then
		return LoginRequests.singleSignOnConnectWithCredential(p2, p3, p4, "EmailOtpSessionToken")
	end

	return LoginRequests.logByOtp(p2, p3, p4, p5, p6)
end

local function loginByOtp(p2, p3, p4, p5, p6, p7)
	return function()
		local v5 = FFlagEnableEmailOtpSsoConnect and getAppFeaturePolicies().getUseSingleSignOn()
		local v6 = p2
		local v7 = p3
		local v8 = p4
		local v9 = p6
		local v10 = p7
		local v11

		if FFlagEnableEmailOtpSsoConnect and getAppFeaturePolicies().getUseSingleSignOn() then
			v11 = LoginRequests.singleSignOnConnectWithCredential(v6, v7, v8, "EmailOtpSessionToken")
		else
			v11 = LoginRequests.logByOtp(v6, v7, v8, v9, v10)
		end

		return v11:andThen(function(list)
			assert(list, "no login attempt result")
			assert(#list == 1, "no result or more than one result")
			local v12 = LoginResult.fromJsonData(list[1])
			assert(v12, "result invalid")

			if v5 then
				local appFeaturePolicies = getAppFeaturePolicies()

				if
					not (appFeaturePolicies.getLinkedAuthEndpointsEnabled() and appFeaturePolicies.getWebViewSupport())
					and LoginResult.hasTwoStepData(v12)
				then
					return Promise.reject({
						errorCode = LoginErrorCodes.ServiceUnavailable,
						errorKey = getFFlagEnableGenericTwoFAMessage() and "Authentication.Login.Response.Require2FAGeneric" or "Authentication.Login.Response.Require2FA"
					})
				end
			end

			if fFlagEnableLastLoginMethodTracking then
				AppStorageUtilities.setLastSuccessfulSignInMethod(LoginMethods.EmailOtp)
			end

			return v12
		end, function(p8)
			local jsonDecode = HttpService:JSONDecode(p8.Body)
			local v12 = nil
			local code = jsonDecode.errors[1].code
			local v13 = nil
			local userFacingMessage = jsonDecode
				and jsonDecode.errors
				and jsonDecode.errors[1]
				and jsonDecode.errors[1].userFacingMessage

			if v5 then
				warn("Login ErrorCode:", code)
				local message = GetLoginByCredentialSsoErrorMessage.getMessage(
					code,
					"Authentication.Login.Response.IncorrectOtpCode",
					"Authentication.Login.Response.UnknownErrorLoginWithDifferentMethod"
				)

				local v14 = if type(message) == "table" then message[1] else message
				LoggingProtocol.default:logRobloxTelemetryEvent(LoginByOtpSSOErrorsTelemetry, nil, {
					ssoErrorCode = code,
					msgShown = v14
				})

				return Promise.reject({
					errorKey = message,
					errorCode = GetLoginByCredentialSsoErrorMessage.getUiErrorCode(code),
					securityQuestionsCallback = p5,
					userFacingMessage = userFacingMessage
				})
			end

			if code == LoginErrorCodes.IncorrectCValueOrPassword then
				v12 = "Authentication.Login.Response.IncorrectOtpCode"
				return Promise.reject({
					errorKey = v12,
					errorCode = code,
					securityQuestionsData = v13,
					securityQuestionsCallback = p5,
					userFacingMessage = userFacingMessage
				})
			end

			if getFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and code == LoginErrorCodes.SecurityQuestions then
				v12 = "Authentication.Login.Response.SomethingWentWrong"

				if jsonDecode.errors[1].fieldData then
					local jsonDecode2 = HttpService:JSONDecode(jsonDecode.errors[1].fieldData)

					if jsonDecode2.sessionId and jsonDecode2.userId then
						v13 = jsonDecode2
						v12 = nil
					end
				end
			else
				if getFFlagEnableLoginAccountSelector() and code == LoginErrorCodes.MultipleUsersPerCredential then
					local v14 = GetMultipleUsersPerCredentialErrorData(jsonDecode)
					return Promise.reject({
						errorKey = v12,
						errorCode = code,
						usersData = v14
					})
				end

				if code == LoginErrorCodes.ServiceUnavailable then
					v12 = "Authentication.Login.Response.ServiceUnavailable"
				elseif defineFastFlag and code == LoginErrorCodes.IllegalChildAccountLinking then
					v12 = "Authentication.Login.LinkIllegalChildAccountLinking"
				elseif code ~= LoginErrorCodes.AccountLocked then
					v12 = "Authentication.Login.Response.UnknownErrorLoginWithDifferentMethod"
				end
			end

			return Promise.reject({
				errorKey = v12,
				errorCode = code,
				securityQuestionsData = v13,
				securityQuestionsCallback = p5,
				userFacingMessage = userFacingMessage
			})
		end)
	end
end

return loginByOtp
