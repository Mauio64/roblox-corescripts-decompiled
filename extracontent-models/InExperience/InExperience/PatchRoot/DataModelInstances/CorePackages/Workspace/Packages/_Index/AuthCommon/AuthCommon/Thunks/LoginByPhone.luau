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
local GetMultipleUsersPerCredentialErrorData = require(AuthCommon.Utils.GetMultipleUsersPerCredentialErrorData)
local LoginMethods = require(AuthCommon.Enums.LoginMethods)
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local recordLogin = require(AuthCommon.Utils.recordLogin)

local GetDxBlob = require(AuthCommon.Utils.GetDxBlob)
local GetCaptchaDataJson = require(AuthCommon.Utils.GetCaptchaDataJson)

local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin = SharedFlags2.GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin
local SharedFlags3 = require(parent.SharedFlags)
local GetFFlagEnableLoginAccountSelector = SharedFlags3.GetFFlagEnableLoginAccountSelector
local SharedFlags4 = require(parent.SharedFlags)
local FFlagEnableLastLoginMethodTracking = SharedFlags4.FFlagEnableLastLoginMethodTracking
local SharedFlags5 = require(parent.SharedFlags)
local FFlagEnableRecordLogin = SharedFlags5.FFlagEnableRecordLogin

local defineFastFlag = game:DefineFastFlag("EnableIllegalChildAccountLinkingErrorMessageOnLoginByPhone", false)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies
local LoggingProtocol = require(parent.LoggingProtocol)
local GetLoginByCredentialSsoErrorMessage = require(AuthCommon.Utils.GetLoginByCredentialSsoErrorMessage)
local LoginByPhoneSSOErrorsTelemetry = require(AuthCommon.Utils.LoginByPhoneSSOErrorsTelemetry)
local SharedFlags6 = require(parent.SharedFlags)
local GetFFlagEnableGenericTwoFAMessage = SharedFlags6.GetFFlagEnableGenericTwoFAMessage
local FFlagEnablePhoneSsoConnect = require(AuthCommon.Flags.FFlagEnablePhoneSsoConnect)

local function loginRequest(p, p2, p3, p4, p5, p6)
	if FFlagEnablePhoneSsoConnect and getAppFeaturePolicies().getUseSingleSignOn() then
		return LoginRequests.singleSignOnConnectWithCredential(p, p2, p3, "PhoneNumber")
	end

	return LoginRequests.logByPhone(p, p2, p3, p4, p5, p6)
end

local function loginByPhone(p, cvalue, p2, captchaCallback, p3, securityQuestionsCallback, p4, p5)
	return function(object)
		local v = FFlagEnablePhoneSsoConnect and getAppFeaturePolicies().getUseSingleSignOn()
		return loginRequest(p, cvalue, p2, p3, p4, p5):andThen(function(list)
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
				AppStorageUtilities.setLastSuccessfulSignInMethod(LoginMethods.Phone)
			end

			if FFlagEnableRecordLogin then
				pcall(function()
					recordLogin(v2, LoginMethods.Phone, cvalue)
				end)
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
					"Authentication.Login.Response.IncorrectPhoneOrPassword",
					"Authentication.Login.Response.UnknownErrorLoginWithDifferentMethod"
				)
				local msgShown

				if type(message) == "table" then
					msgShown = message[1]
				else
					msgShown = message
				end

				LoggingProtocol.default:logRobloxTelemetryEvent(LoginByPhoneSSOErrorsTelemetry, nil, {
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
				errorKey = "Authentication.Login.Response.IncorrectPhoneOrPassword"
				return Promise.reject({
					errorKey = errorKey,
					errorCode = code,
					securityQuestionsData = securityQuestionsData,
					securityQuestionsCallback = securityQuestionsCallback,
					userFacingMessage = userFacingMessage
				})
			end

			if code == LoginErrorCodes.Captcha then
				GetDxBlob(jsonDecode)

				local captchaId, dxBlob = GetCaptchaDataJson(jsonDecode)

				local v2 = {
					name = AppPage.CaptchaNative,
					detail = "",
					extraProps = {
						captchaCallback = captchaCallback,
						captchaType = "login",
						captchaId = captchaId,
						cvalueType = "phonenumber",
						cvalue = cvalue,
						dxBlob = dxBlob,
						backNavigationDisabledWhileLoading = true
					}
				}

				if FFlagSignalsNavP3Dispatch then
					navigationCommands.down(navigationCommands.fromLegacyPage(v2))
				else
					object:dispatch(NavigateDown(v2))
				end

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
						usersData = usersData,
						userFacingMessage = userFacingMessage
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

return loginByPhone
