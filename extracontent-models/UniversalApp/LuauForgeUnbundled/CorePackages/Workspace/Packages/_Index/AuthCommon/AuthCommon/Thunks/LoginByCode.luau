local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local LoginRequests = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/LoginRequests")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppEnums").AppPage
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppNavigation").NavigationCommands else nil

local LoginResult = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Models/LoginResult")
local LoginErrorCodes = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginErrorCodes")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/LoggingProtocol")
local LoginByUsernameSSOErrorsTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/LoginByUsernameSSOErrorsTelemetry")
local GetLoginByUsernameErrorMessage = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/GetLoginByUsernameErrorMessage")
local LoginMethods = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginMethods")
local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")
local recordLogin = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/recordLogin")

local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UniversalAppPolicy").getAppFeaturePolicies

local GetDxBlob = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/GetDxBlob")
local GetCaptchaDataJson = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/GetCaptchaDataJson")

local getFFlagLuaAppUsingSecurityQuestionsForLuaLogin = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin
local fFlagEnableLastLoginMethodTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEnableLastLoginMethodTracking
local fFlagEnableRecordLogin = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEnableRecordLogin

local defineFastFlag = game:DefineFastFlag(
	"EnableIllegalChildAccountLinkingErrorMessageOnLoginByCode",
	false
)

local function loginRequest(p2, p3, p4, p5, p6)
	if getAppFeaturePolicies().getUseSingleSignOn() then
		return LoginRequests.singleSignOnConnectWithCode(p2, p3, p4)
	end

	return LoginRequests.loginWithCode(p2, p3, p4, p5, p6)
end

local function loginByCode(p2, p3, p4, p5, p6, p7, p8)
	return function(object)
		local useSingleSignOn = getAppFeaturePolicies().getUseSingleSignOn()
		local v5 = p2
		local v6 = p3
		local v7 = p4
		local v8 = p6
		local v9 = p8
		local v10

		if getAppFeaturePolicies().getUseSingleSignOn() then
			v10 = LoginRequests.singleSignOnConnectWithCode(v5, v6, v7)
		else
			v10 = LoginRequests.loginWithCode(v5, v6, v7, v8, v9)
		end

		return v10:andThen(function(list)
			assert(list, "no login attempt result")
			assert(#list == 1, "no result or more than one result")
			assert(LoginResult.fromJsonData(list[1]), "result invalid")

			if fFlagEnableLastLoginMethodTracking then
				AppStorageUtilities.setLastSuccessfulSignInMethod(LoginMethods.QuickLogin)
			end

			local v11 = LoginResult.fromJsonData(list[1])

			if fFlagEnableRecordLogin then
				pcall(function()
					recordLogin(v11, LoginMethods.QuickLogin, v11.user.name)
				end)
			end

			return v11
		end, function(p9)
			local jsonDecode = HttpService:JSONDecode(p9.Body)
			local code = jsonDecode
				and jsonDecode.errors
				and jsonDecode.errors[1]
				and jsonDecode.errors[1].code
			local v11 = nil
			local v12 = nil
			local userFacingMessage = jsonDecode
				and jsonDecode.errors
				and jsonDecode.errors[1]
				and jsonDecode.errors[1].userFacingMessage

			if code == LoginErrorCodes.Captcha then
				GetDxBlob(jsonDecode)

				local v13, v14 = GetCaptchaDataJson(jsonDecode)
				local v15 = {
					name = appPage.CaptchaNative,
					detail = "",
					extraProps = {
						captchaCallback = p5,
						captchaType = "login",
						cvalueType = "authToken",
						captchaId = v13,
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
				v12 = "Authentication.Login.Response.SomethingWentWrong"

				if jsonDecode.errors[1].fieldData then
					local jsonDecode2 = HttpService:JSONDecode(jsonDecode.errors[1].fieldData)

					if jsonDecode2.sessionId and jsonDecode2.userId then
						v11 = jsonDecode2
						v12 = nil
					end
				end
			elseif defineFastFlag and code == LoginErrorCodes.IllegalChildAccountLinking then
				v12 = "Authentication.Login.LinkIllegalChildAccountLinking"
			end

			if useSingleSignOn then
				warn("Login ErrorCode:", code)
				v12 = GetLoginByUsernameErrorMessage(code)
				local v13 = if v12[1] then v12[1] else v12
				LoggingProtocol.default:logRobloxTelemetryEvent(LoginByUsernameSSOErrorsTelemetry, nil, {
					ssoErrorCode = code,
					msgShown = v13
				})
			end

			return Promise.reject({
				errorKey = v12,
				errorCode = code,
				securityQuestionsData = v11,
				securityQuestionsCallback = p7,
				userFacingMessage = userFacingMessage
			})
		end)
	end
end

return loginByCode
