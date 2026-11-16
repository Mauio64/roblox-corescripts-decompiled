local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local LoginRequests = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/LoginRequests")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppNavigation").NavigationCommands else nil

local LoginResult = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Models/LoginResult")
local LoginErrorCodes = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginErrorCodes")
local LoginMethods = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginMethods")
local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")
local GetMultipleUsersPerCredentialErrorData = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/GetMultipleUsersPerCredentialErrorData")

local GetDxBlob = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/GetDxBlob")
local GetCaptchaDataJson = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/GetCaptchaDataJson")
local GetLoginByCredentialSsoErrorMessage = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/GetLoginByCredentialSsoErrorMessage")
local LoginByEmailSSOErrorsTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/LoginByEmailSSOErrorsTelemetry")

local getFFlagLuaAppUsingSecurityQuestionsForLuaLogin = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin
local getFFlagEnableLoginAccountSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagEnableLoginAccountSelector
local getFFlagEnableGenericTwoFAMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagEnableGenericTwoFAMessage
local fFlagEnableLastLoginMethodTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEnableLastLoginMethodTracking
local recordLogin = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/recordLogin")
local fFlagEnableRecordLogin = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEnableRecordLogin
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/LoggingProtocol")
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UniversalAppPolicy").getAppFeaturePolicies

local defineFastFlag = game:DefineFastFlag(
	"EnableIllegalChildAccountLinkingErrorMessageOnLoginByEmail",
	false
)
local FFlagEnableEmailSsoConnect = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Flags/FFlagEnableEmailSsoConnect")

local function loginRequest(p2, p3, p4, p5, p6, p7)
	if FFlagEnableEmailSsoConnect and getAppFeaturePolicies().getUseSingleSignOn() then
		return LoginRequests.singleSignOnConnectWithCredential(p2, p3, p4, "Email")
	end

	return LoginRequests.logByEmail(p2, p3, p4, p5, p6, p7)
end

local function loginByEmail(p2, p3, p4, p5, p6, p7, p8, p9)
	return function(object)
		local v5 = FFlagEnableEmailSsoConnect and getAppFeaturePolicies().getUseSingleSignOn()
		return loginRequest(p2, p3, p4, p6, p8, p9):andThen(function(list)
			assert(list, "no login attempt result")
			assert(#list == 1, "no result or more than one result")
			local v6 = LoginResult.fromJsonData(list[1])
			assert(v6, "result invalid")

			if v5 then
				local appFeaturePolicies = getAppFeaturePolicies()

				if
					not (appFeaturePolicies.getLinkedAuthEndpointsEnabled() and appFeaturePolicies.getWebViewSupport())
					and LoginResult.hasTwoStepData(v6)
				then
					return Promise.reject({
						errorCode = LoginErrorCodes.ServiceUnavailable,
						errorKey = getFFlagEnableGenericTwoFAMessage() and "Authentication.Login.Response.Require2FAGeneric" or "Authentication.Login.Response.Require2FA"
					})
				end
			end

			if fFlagEnableLastLoginMethodTracking then
				AppStorageUtilities.setLastSuccessfulSignInMethod(LoginMethods.Email)
			end

			if fFlagEnableRecordLogin then
				pcall(function()
					recordLogin(v6, LoginMethods.Email, p3)
				end)
			end

			return v6
		end, function(p10)
			local jsonDecode = HttpService:JSONDecode(p10.Body)
			local v6 = nil
			local code = jsonDecode.errors[1].code
			local v7 = nil
			local userFacingMessage = jsonDecode
				and jsonDecode.errors
				and jsonDecode.errors[1]
				and jsonDecode.errors[1].userFacingMessage

			if v5 then
				warn("Login ErrorCode:", code)
				local message = GetLoginByCredentialSsoErrorMessage.getMessage(
					code,
					"Authentication.Login.Response.IncorrectEmailOrPassword",
					"Authentication.Login.Response.UnverifiedEmailLoginWithUsername"
				)

				local v8 = if type(message) == "table" then message[1] else message
				LoggingProtocol.default:logRobloxTelemetryEvent(LoginByEmailSSOErrorsTelemetry, nil, {
					ssoErrorCode = code,
					msgShown = v8
				})

				return Promise.reject({
					errorKey = message,
					errorCode = GetLoginByCredentialSsoErrorMessage.getUiErrorCode(code),
					securityQuestionsCallback = p7,
					userFacingMessage = userFacingMessage
				})
			end

			if code == LoginErrorCodes.IncorrectCValueOrPassword then
				v6 = "Authentication.Login.Response.IncorrectEmailOrPassword"
				return Promise.reject({
					errorKey = v6,
					errorCode = code,
					securityQuestionsData = v7,
					securityQuestionsCallback = p7,
					userFacingMessage = userFacingMessage
				})
			end

			if code == LoginErrorCodes.Captcha then
				GetDxBlob(jsonDecode)

				local v8, v9 = GetCaptchaDataJson(jsonDecode)

				local v10 = {
					name = appPage.CaptchaNative,
					detail = "",
					extraProps = {
						captchaCallback = p5,
						captchaType = "login",
						cvalueType = "email",
						captchaId = v8,
						cvalue = p3,
						dxBlob = v9,
						backNavigationDisabledWhileLoading = true
					}
				}

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v10))
				else
					object:dispatch(navigateDown(v10))
				end

				return Promise.reject({
					errorKey = v6,
					errorCode = code,
					securityQuestionsData = v7,
					securityQuestionsCallback = p7,
					userFacingMessage = userFacingMessage
				})
			end

			if getFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and code == LoginErrorCodes.SecurityQuestions then
				v6 = "Authentication.Login.Response.SomethingWentWrong"

				if jsonDecode.errors[1].fieldData then
					local jsonDecode2 = HttpService:JSONDecode(jsonDecode.errors[1].fieldData)

					if jsonDecode2.sessionId and jsonDecode2.userId then
						v7 = jsonDecode2
						v6 = nil
					end
				end
			else
				if getFFlagEnableLoginAccountSelector() and code == LoginErrorCodes.MultipleUsersPerCredential then
					local v8 = GetMultipleUsersPerCredentialErrorData(jsonDecode)
					return Promise.reject({
						errorKey = v6,
						errorCode = code,
						usersData = v8
					})
				end

				if code == LoginErrorCodes.MoreThanOneUsername then
					v6 = "Authentication.Login.Response.MoreThanOneUsername"
				elseif code == LoginErrorCodes.ServiceUnavailable then
					v6 = "Authentication.Login.Response.ServiceUnavailable"
				elseif code == LoginErrorCodes.AccountNotVerified then
					v6 = "Authentication.Login.Response.UnverifiedEmailLoginWithUsername"
				elseif defineFastFlag and code == LoginErrorCodes.IllegalChildAccountLinking then
					v6 = "Authentication.Login.LinkIllegalChildAccountLinking"
				elseif code ~= LoginErrorCodes.AccountLocked then
					v6 = "Authentication.Login.Response.UnknownErrorLoginWithDifferentMethod"
				end
			end

			return Promise.reject({
				errorKey = v6,
				errorCode = code,
				securityQuestionsData = v7,
				securityQuestionsCallback = p7,
				userFacingMessage = userFacingMessage
			})
		end)
	end
end

return loginByEmail
