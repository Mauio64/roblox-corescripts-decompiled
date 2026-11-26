local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local LoginRequests = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/LoginRequests")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppNavigation").NavigationCommands else nil

local LoginResult = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Models/LoginResult")
local LoginErrorCodes = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginErrorCodes")
local LoginByUsernameSSOErrorsTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/LoginByUsernameSSOErrorsTelemetry")
local GetLoginByUsernameErrorMessage = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/GetLoginByUsernameErrorMessage")
local LoginMethods = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginMethods")
local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")
local recordLogin = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/recordLogin")

local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/LoggingProtocol")
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UniversalAppPolicy").getAppFeaturePolicies

local GetDxBlob = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/GetDxBlob")
local GetCaptchaDataJson = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/GetCaptchaDataJson")

local getFFlagLuaAppUsingSecurityQuestionsForLuaLogin = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin
local getFFlagEnableGenericTwoFAMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagEnableGenericTwoFAMessage
local fFlagEnableLastLoginMethodTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEnableLastLoginMethodTracking
local defineFastFlag = game:DefineFastFlag("EnablePasskeyOnlyUserErrorMessage", false)
local fFlagEnableRecordLogin = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEnableRecordLogin

local defineFastFlag2 = game:DefineFastFlag(
	"EnableIllegalChildAccountLinkingErrorMessageOnLoginByUsername",
	false
)
local defineFastFlag3 = game:DefineFastFlag("EnableLoginNetworkingErrorToast", false)
local setNetworkingErrorToast = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/RobloxAppToastsRodux").Thunks.SetNetworkingErrorToast

local function loginRequest(p2, p3, p4, p5, p6)
	if getAppFeaturePolicies().getUseSingleSignOn() then
		return LoginRequests.singleSignOnConnectWithCredential(p2, p3, p4, "Username")
	end

	return LoginRequests.logByUsername(p2, p3, p4, p5, p6)
end

local function loginByUsername(p2, p3, p4, p5, p6, p7, p8)
	return function(object)
		local useSingleSignOn = getAppFeaturePolicies().getUseSingleSignOn()
		local v5 = p2
		local v6 = p3
		local v7 = p4
		local v8 = p6
		local v9 = p8
		local v10

		if getAppFeaturePolicies().getUseSingleSignOn() then
			v10 = LoginRequests.singleSignOnConnectWithCredential(v5, v6, v7, "Username")
		else
			v10 = LoginRequests.logByUsername(v5, v6, v7, v8, v9)
		end

		return v10:andThen(function(list)
			assert(list, "no login attempt result")
			assert(#list == 1, "no result or more than one result")
			local v11 = LoginResult.fromJsonData(list[1])
			assert(v11, "result invalid")
			local appFeaturePolicies = getAppFeaturePolicies()

			if
				(useSingleSignOn and not appFeaturePolicies.getLinkedAuthEndpointsEnabled() or not appFeaturePolicies.getWebViewSupport())
				and v11
				and LoginResult.hasTwoStepData(v11)
			then
				return Promise.reject({
					errorCode = LoginErrorCodes.ServiceUnavailable,
					errorKey = getFFlagEnableGenericTwoFAMessage() and "Authentication.Login.Response.Require2FAGeneric" or "Authentication.Login.Response.Require2FA"
				})
			end

			if fFlagEnableLastLoginMethodTracking then
				AppStorageUtilities.setLastSuccessfulSignInMethod(LoginMethods.Username)
			end

			if fFlagEnableRecordLogin then
				pcall(function()
					recordLogin(v11, LoginMethods.Username, p3)
				end)
			end

			return v11
		end, function(p9)
			if
				defineFastFlag3
				and p9.Body == nil
				and p9.HttpError ~= nil
				and p9.HttpError ~= Enum.HttpError.OK
			then
				object:dispatch(setNetworkingErrorToast(p9))
				return Promise.reject({ errorKey = nil, errorCode = nil })
			end

			local jsonDecode = HttpService:JSONDecode(p9.Body)
			local v11 = nil
			local code = jsonDecode.errors[1].code
			local v12 = nil
			local userFacingMessage = jsonDecode
				and jsonDecode.errors
				and jsonDecode.errors[1]
				and jsonDecode.errors[1].userFacingMessage

			if code == LoginErrorCodes.IncorrectCValueOrPassword then
				v11 = "Authentication.Login.Response.IncorrectUsernamePassword"
			elseif code == LoginErrorCodes.Captcha then
				GetDxBlob(jsonDecode)

				local v13, v14 = GetCaptchaDataJson(jsonDecode)

				local v15 = {
					name = appPage.CaptchaNative,
					detail = "",
					extraProps = {
						captchaCallback = p5,
						captchaType = "login",
						captchaId = v13,
						cvalueType = "username",
						cvalue = p3,
						dxBlob = v14,
						backNavigationDisabledWhileLoading = true
					}
				}

				if fFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v15))
				else
					object:dispatch(navigateDown(v15))
				end
			elseif
				getFFlagLuaAppUsingSecurityQuestionsForLuaLogin()
				and code == LoginErrorCodes.SecurityQuestions
			then
				v11 = "Authentication.Login.Response.SomethingWentWrong"

				if jsonDecode.errors[1].fieldData then
					local jsonDecode2 = HttpService:JSONDecode(jsonDecode.errors[1].fieldData)

					if jsonDecode2.sessionId and jsonDecode2.userId then
						v12 = jsonDecode2
						v11 = nil
					end
				end
			elseif code == LoginErrorCodes.ServiceUnavailable then
				v11 = "Authentication.Login.Response.ServiceUnavailable"
			elseif defineFastFlag2 and code == LoginErrorCodes.IllegalChildAccountLinking then
				v11 = "Authentication.Login.LinkIllegalChildAccountLinking"
			elseif defineFastFlag and code == LoginErrorCodes.PasskeyOnlyUser then
				v11 = "Authentication.Login.Error.PasskeyOnlyAccount"
			elseif code ~= LoginErrorCodes.AccountLocked then
				v11 = "Authentication.Login.Response.SomethingWentWrong"
			end

			if useSingleSignOn then
				warn("Login ErrorCode:", code)
				v11 = GetLoginByUsernameErrorMessage(code)

				local v13 = if v11[1] then v11[1] else v11
				LoggingProtocol.default:logRobloxTelemetryEvent(LoginByUsernameSSOErrorsTelemetry, nil, {
					ssoErrorCode = code,
					msgShown = v13
				})
			end

			return Promise.reject({
				errorKey = v11,
				errorCode = code,
				securityQuestionsData = v12,
				securityQuestionsCallback = p7,
				userFacingMessage = userFacingMessage
			})
		end)
	end
end

return loginByUsername
