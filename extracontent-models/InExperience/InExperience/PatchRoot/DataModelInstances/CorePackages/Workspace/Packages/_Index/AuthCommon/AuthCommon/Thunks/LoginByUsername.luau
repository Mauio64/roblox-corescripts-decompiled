local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local HttpService = game:GetService("HttpService")

local Promise = require(parent.Promise)
local LoginRequests = require(AuthCommon.Http.Requests.LoginRequests)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local LoginResult = require(AuthCommon.Models.LoginResult)
local LoginErrorCodes = require(AuthCommon.Enums.LoginErrorCodes)
local LoginByUsernameSSOErrorsTelemetry = require(AuthCommon.Utils.LoginByUsernameSSOErrorsTelemetry)
local GetLoginByUsernameErrorMessage = require(AuthCommon.Utils.GetLoginByUsernameErrorMessage)
local LoginMethods = require(AuthCommon.Enums.LoginMethods)
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local recordLogin = require(AuthCommon.Utils.recordLogin)

local LoggingProtocol = require(parent.LoggingProtocol)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local GetDxBlob = require(AuthCommon.Utils.GetDxBlob)
local GetCaptchaDataJson = require(AuthCommon.Utils.GetCaptchaDataJson)

local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin = SharedFlags2.GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin
local SharedFlags3 = require(parent.SharedFlags)
local GetFFlagEnableGenericTwoFAMessage = SharedFlags3.GetFFlagEnableGenericTwoFAMessage
local SharedFlags4 = require(parent.SharedFlags)
local FFlagEnableLastLoginMethodTracking = SharedFlags4.FFlagEnableLastLoginMethodTracking
local defineFastFlag = game:DefineFastFlag("EnablePasskeyOnlyUserErrorMessage", false)
local SharedFlags5 = require(parent.SharedFlags)
local FFlagEnableRecordLogin = SharedFlags5.FFlagEnableRecordLogin

local defineFastFlag2 = game:DefineFastFlag("EnableIllegalChildAccountLinkingErrorMessageOnLoginByUsername", false)
local defineFastFlag3 = game:DefineFastFlag("EnableLoginNetworkingErrorToast", false)
local RobloxAppToastsRodux = require(parent.RobloxAppToastsRodux)
local SetNetworkingErrorToast = RobloxAppToastsRodux.Thunks.SetNetworkingErrorToast

local function loginRequest(p, p2, p3, p4, p5) -- 1 equivalent call inferred from this helper
	if getAppFeaturePolicies().getUseSingleSignOn() then
		return LoginRequests.singleSignOnConnectWithCredential(p, p2, p3, "Username")
	end

	return LoginRequests.logByUsername(p, p2, p3, p4, p5)
end

local function loginByUsername(p, cvalue, p2, captchaCallback, p3, securityQuestionsCallback, p4)
	return function(object)
		local useSingleSignOn = getAppFeaturePolicies().getUseSingleSignOn()
		return loginRequest(p, cvalue, p2, p3, p4):andThen(function(list) -- inferred equivalent call
			assert(list, "no login attempt result")
			assert(#list == 1, "no result or more than one result")
			local v = LoginResult.fromJsonData(list[1])
			assert(v, "result invalid")
			local appFeaturePolicies = getAppFeaturePolicies()

			if
				(useSingleSignOn and not appFeaturePolicies.getLinkedAuthEndpointsEnabled() or not appFeaturePolicies.getWebViewSupport())
				and v
				and LoginResult.hasTwoStepData(v)
			then
				return Promise.reject({
					errorCode = LoginErrorCodes.ServiceUnavailable,
					errorKey = GetFFlagEnableGenericTwoFAMessage() and "Authentication.Login.Response.Require2FAGeneric" or "Authentication.Login.Response.Require2FA"
				})
			end

			if FFlagEnableLastLoginMethodTracking then
				AppStorageUtilities.setLastSuccessfulSignInMethod(LoginMethods.Username)
			end

			if FFlagEnableRecordLogin then
				pcall(function()
					recordLogin(v, LoginMethods.Username, cvalue)
				end)
			end

			return v
		end, function(p5)
			if defineFastFlag3 and p5.Body == nil and p5.HttpError ~= nil and p5.HttpError ~= Enum.HttpError.OK then
				object:dispatch(SetNetworkingErrorToast(p5))
				return Promise.reject({ errorKey = nil, errorCode = nil })
			end

			local jsonDecode = HttpService:JSONDecode(p5.Body)
			local errorKey = nil
			local code = jsonDecode.errors[1].code
			local securityQuestionsData = nil
			local userFacingMessage = jsonDecode
				and jsonDecode.errors
				and jsonDecode.errors[1]
				and jsonDecode.errors[1].userFacingMessage

			if code == LoginErrorCodes.IncorrectCValueOrPassword then
				errorKey = "Authentication.Login.Response.IncorrectUsernamePassword"
			elseif code == LoginErrorCodes.Captcha then
				GetDxBlob(jsonDecode)

				local captchaId, dxBlob = GetCaptchaDataJson(jsonDecode)

				local v = {
					name = AppPage.CaptchaNative,
					detail = "",
					extraProps = {
						captchaCallback = captchaCallback,
						captchaType = "login",
						captchaId = captchaId,
						cvalueType = "username",
						cvalue = cvalue,
						dxBlob = dxBlob,
						backNavigationDisabledWhileLoading = true
					}
				}

				if FFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v))
				else
					object:dispatch(NavigateDown(v))
				end
			elseif GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and code == LoginErrorCodes.SecurityQuestions then
				errorKey = "Authentication.Login.Response.SomethingWentWrong"

				if jsonDecode.errors[1].fieldData then
					local jsonDecode2 = HttpService:JSONDecode(jsonDecode.errors[1].fieldData)

					if jsonDecode2.sessionId and jsonDecode2.userId then
						securityQuestionsData = jsonDecode2
						errorKey = nil
					end
				end
			elseif code == LoginErrorCodes.ServiceUnavailable then
				errorKey = "Authentication.Login.Response.ServiceUnavailable"
			elseif defineFastFlag2 and code == LoginErrorCodes.IllegalChildAccountLinking then
				errorKey = "Authentication.Login.LinkIllegalChildAccountLinking"
			elseif defineFastFlag and code == LoginErrorCodes.PasskeyOnlyUser then
				errorKey = "Authentication.Login.Error.PasskeyOnlyAccount"
			elseif code ~= LoginErrorCodes.AccountLocked then
				errorKey = "Authentication.Login.Response.SomethingWentWrong"
			end

			if useSingleSignOn then
				warn("Login ErrorCode:", code)
				errorKey = GetLoginByUsernameErrorMessage(code)
				local msgShown

				if errorKey[1] then
					msgShown = errorKey[1]
				else
					msgShown = errorKey
				end

				LoggingProtocol.default:logRobloxTelemetryEvent(LoginByUsernameSSOErrorsTelemetry, nil, {
					ssoErrorCode = code,
					msgShown = msgShown
				})
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

return loginByUsername
