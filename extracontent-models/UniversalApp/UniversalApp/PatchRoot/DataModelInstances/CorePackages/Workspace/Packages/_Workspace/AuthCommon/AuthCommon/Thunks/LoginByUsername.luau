local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local HttpService = game:GetService("HttpService")
local Promise = require(AuthCommonParent.Promise)
local LoginRequests = require(AuthCommon.Http.Requests.LoginRequests)
local AppPage = require(AuthCommonParent.RobloxAppEnums).AppPage
local NavigateDown = require(AuthCommonParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(AuthCommonParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v9 = if not FFlagSignalsNavP3Dispatch then nil else require(AuthCommonParent.RobloxAppNavigation).NavigationCommands
local LoginResult = require(AuthCommon.Models.LoginResult)
local LoginErrorCodes = require(AuthCommon.Enums.LoginErrorCodes)
local LoginByUsernameSSOErrorsTelemetry = require(AuthCommon.Utils.LoginByUsernameSSOErrorsTelemetry)
local GetLoginByUsernameErrorMessage = require(AuthCommon.Utils.GetLoginByUsernameErrorMessage)
local LoginMethods = require(AuthCommon.Enums.LoginMethods)
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local recordLogin = require(AuthCommon.Utils.recordLogin)
local LoggingProtocol = require(AuthCommonParent.LoggingProtocol)
local getAppFeaturePolicies = require(AuthCommonParent.UniversalAppPolicy).getAppFeaturePolicies
local GetDxBlob = require(AuthCommon.Utils.GetDxBlob)
local GetCaptchaDataJson = require(AuthCommon.Utils.GetCaptchaDataJson)
local GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin = require(AuthCommonParent.SharedFlags).GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin
local GetFFlagEnableGenericTwoFAMessage = require(AuthCommonParent.SharedFlags).GetFFlagEnableGenericTwoFAMessage
local FFlagEnableLastLoginMethodTracking = require(AuthCommonParent.SharedFlags).FFlagEnableLastLoginMethodTracking
local v24 = game:DefineFastFlag("EnablePasskeyOnlyUserErrorMessage", false)
local FFlagEnableRecordLogin = require(AuthCommonParent.SharedFlags).FFlagEnableRecordLogin
local v26 = game:DefineFastFlag("EnableIllegalChildAccountLinkingErrorMessageOnLoginByUsername", false)

local function loginRequest(p1, p2, p3, p4, p5) -- line: 38
	-- upvalues: getAppFeaturePolicies (copy), LoginRequests (copy)
	if getAppFeaturePolicies().getUseSingleSignOn() then
		return LoginRequests.singleSignOnConnectWithCredential(p1, p2, p3, "Username")
	end

	return LoginRequests.logByUsername(p1, p2, p3, p4, p5)
end
local function loginByUsername(p6, p7, p8, p9, p10, p11, p12) -- line: 48
	-- upvalues: getAppFeaturePolicies (copy), LoginRequests (copy), LoginResult (copy), Promise (copy), LoginErrorCodes (copy), GetFFlagEnableGenericTwoFAMessage (copy), FFlagEnableLastLoginMethodTracking (copy), AppStorageUtilities (copy), LoginMethods (copy), FFlagEnableRecordLogin (copy), recordLogin (copy), HttpService (copy), GetDxBlob (copy), GetCaptchaDataJson (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), v26 (copy), v24 (copy), GetLoginByUsernameErrorMessage (copy), LoggingProtocol (copy), LoginByUsernameSSOErrorsTelemetry (copy)
	return function(p13) -- line: 57
		-- upvalues: getAppFeaturePolicies (copy), p6 (copy), p7 (copy), p8 (copy), p10 (copy), p12 (copy), LoginRequests (copy), LoginResult (copy), Promise (copy), LoginErrorCodes (copy), GetFFlagEnableGenericTwoFAMessage (copy), FFlagEnableLastLoginMethodTracking (copy), AppStorageUtilities (copy), LoginMethods (copy), FFlagEnableRecordLogin (copy), recordLogin (copy), HttpService (copy), GetDxBlob (copy), GetCaptchaDataJson (copy), AppPage (copy), p9 (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), v26 (copy), v24 (copy), GetLoginByUsernameErrorMessage (copy), LoggingProtocol (copy), LoginByUsernameSSOErrorsTelemetry (copy), p11 (copy)
		local v42 = getAppFeaturePolicies().getUseSingleSignOn()
		local v43 = p6
		local v44 = p7
		local v45 = p8
		local v46 = p10
		local v47 = p12

		return ((if not getAppFeaturePolicies().getUseSingleSignOn() then LoginRequests.logByUsername(v43, v44, v45, v46, v47) else LoginRequests.singleSignOnConnectWithCredential(v43, v44, v45, "Username"))):andThen(function(p14) -- line: 59
			-- upvalues: LoginResult (copy), getAppFeaturePolicies (copy), v42 (copy), Promise (copy), LoginErrorCodes (copy), GetFFlagEnableGenericTwoFAMessage (copy), FFlagEnableLastLoginMethodTracking (copy), AppStorageUtilities (copy), LoginMethods (copy), FFlagEnableRecordLogin (copy), recordLogin (copy), p7 (copy)
			assert(p14, "no login attempt result")
			assert(#p14 == 1, "no result or more than one result")

			local v49 = LoginResult.fromJsonData(p14[1])

			assert(v49, "result invalid")

			local v50 = getAppFeaturePolicies()

			if (v42 and not v50.getLinkedAuthEndpointsEnabled() or not v50.getWebViewSupport()) and v49 and LoginResult.hasTwoStepData(v49) then
				return Promise.reject({
					errorCode = LoginErrorCodes.ServiceUnavailable,
					errorKey = not GetFFlagEnableGenericTwoFAMessage() and "Authentication.Login.Response.Require2FA" or "Authentication.Login.Response.Require2FAGeneric"
				})
			end

			if FFlagEnableLastLoginMethodTracking then
				AppStorageUtilities.setLastSuccessfulSignInMethod(LoginMethods.Username)
			end

			if FFlagEnableRecordLogin then
				pcall(function() -- line: 85
					-- upvalues: recordLogin (copy), v49 (copy), LoginMethods (copy), p7 (copy)
					recordLogin(v49, LoginMethods.Username, p7)
				end)
			end

			return v49
		end, function(p15) -- line: 91
			-- upvalues: HttpService (copy), LoginErrorCodes (copy), GetDxBlob (copy), GetCaptchaDataJson (copy), AppPage (copy), p9 (copy), p7 (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), p13 (copy), NavigateDown (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), v26 (copy), v24 (copy), v42 (copy), GetLoginByUsernameErrorMessage (copy), LoggingProtocol (copy), LoginByUsernameSSOErrorsTelemetry (copy), Promise (copy), p11 (copy)
			local data = HttpService:JSONDecode(p15.Body)
			local s1 = nil
			local code = data.errors[1].code
			local v55 = nil
			local v56 = data and (data.errors and (data.errors[1] and data.errors[1].userFacingMessage))

			if code == LoginErrorCodes.IncorrectCValueOrPassword then
				s1 = "Authentication.Login.Response.IncorrectUsernamePassword"
			elseif code == LoginErrorCodes.Captcha then
				GetDxBlob(data)

				local v57, v58 = GetCaptchaDataJson(data)
				local t1 = {
					detail = "",
					name = AppPage.CaptchaNative,
					extraProps = {
						captchaType = "login",
						cvalueType = "username",
						backNavigationDisabledWhileLoading = true,
						captchaCallback = p9,
						captchaId = v57,
						cvalue = p7,
						dxBlob = v58
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v9.down(v9.fromLegacyPage(t1))
				else
					p13:dispatch(NavigateDown(t1))
				end
			elseif GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and code == LoginErrorCodes.SecurityQuestions then
				s1 = "Authentication.Login.Response.SomethingWentWrong"

				if data.errors[1].fieldData then
					local data2 = HttpService:JSONDecode(data.errors[1].fieldData)

					if data2.sessionId and data2.userId then
						v55 = data2
						s1 = nil
					end
				end
			elseif code == LoginErrorCodes.ServiceUnavailable then
				s1 = "Authentication.Login.Response.ServiceUnavailable"
			elseif v26 and code == LoginErrorCodes.IllegalChildAccountLinking then
				s1 = "Authentication.Login.LinkIllegalChildAccountLinking"
			elseif v24 and code == LoginErrorCodes.PasskeyOnlyUser then
				s1 = "Authentication.Login.Error.PasskeyOnlyAccount"
			elseif code ~= LoginErrorCodes.AccountLocked then
				s1 = "Authentication.Login.Response.SomethingWentWrong"
			end

			if v42 then
				warn("Login ErrorCode:", code)
				s1 = GetLoginByUsernameErrorMessage(code)

				local v61 = if not s1[1] then s1 else s1[1]

				LoggingProtocol.default:logRobloxTelemetryEvent(LoginByUsernameSSOErrorsTelemetry, nil, {
					ssoErrorCode = code,
					msgShown = v61
				})
			end

			return Promise.reject({
				errorKey = s1,
				errorCode = code,
				securityQuestionsData = v55,
				securityQuestionsCallback = p11,
				userFacingMessage = v56
			})
		end)
	end
end

return loginByUsername
