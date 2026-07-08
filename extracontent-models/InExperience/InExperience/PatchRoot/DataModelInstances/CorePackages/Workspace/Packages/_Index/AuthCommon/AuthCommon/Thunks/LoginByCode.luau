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
local LoggingProtocol = require(AuthCommonParent.LoggingProtocol)
local LoginByUsernameSSOErrorsTelemetry = require(AuthCommon.Utils.LoginByUsernameSSOErrorsTelemetry)
local GetLoginByUsernameErrorMessage = require(AuthCommon.Utils.GetLoginByUsernameErrorMessage)
local LoginMethods = require(AuthCommon.Enums.LoginMethods)
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local recordLogin = require(AuthCommon.Utils.recordLogin)
local getAppFeaturePolicies = require(AuthCommonParent.UniversalAppPolicy).getAppFeaturePolicies
local GetDxBlob = require(AuthCommon.Utils.GetDxBlob)
local GetCaptchaDataJson = require(AuthCommon.Utils.GetCaptchaDataJson)
local GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin = require(AuthCommonParent.SharedFlags).GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin
local FFlagEnableLastLoginMethodTracking = require(AuthCommonParent.SharedFlags).FFlagEnableLastLoginMethodTracking
local FFlagEnableRecordLogin = require(AuthCommonParent.SharedFlags).FFlagEnableRecordLogin
local v24 = game:DefineFastFlag("EnableIllegalChildAccountLinkingErrorMessageOnLoginByCode", false)

local function loginRequest(p1, p2, p3, p4, p5) -- line: 35
	-- upvalues: getAppFeaturePolicies (copy), LoginRequests (copy)
	if getAppFeaturePolicies().getUseSingleSignOn() then
		return LoginRequests.singleSignOnConnectWithCode(p1, p2, p3)
	end

	return LoginRequests.loginWithCode(p1, p2, p3, p4, p5)
end
local function loginByCode(p6, p7, p8, p9, p10, p11, p12) -- line: 44
	-- upvalues: getAppFeaturePolicies (copy), LoginRequests (copy), LoginResult (copy), FFlagEnableLastLoginMethodTracking (copy), AppStorageUtilities (copy), LoginMethods (copy), FFlagEnableRecordLogin (copy), recordLogin (copy), HttpService (copy), LoginErrorCodes (copy), GetDxBlob (copy), GetCaptchaDataJson (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), v24 (copy), GetLoginByUsernameErrorMessage (copy), LoggingProtocol (copy), LoginByUsernameSSOErrorsTelemetry (copy), Promise (copy)
	return function(p13) -- line: 53
		-- upvalues: getAppFeaturePolicies (copy), p6 (copy), p7 (copy), p8 (copy), p10 (copy), p12 (copy), LoginRequests (copy), LoginResult (copy), FFlagEnableLastLoginMethodTracking (copy), AppStorageUtilities (copy), LoginMethods (copy), FFlagEnableRecordLogin (copy), recordLogin (copy), HttpService (copy), LoginErrorCodes (copy), GetDxBlob (copy), GetCaptchaDataJson (copy), AppPage (copy), p9 (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), v24 (copy), GetLoginByUsernameErrorMessage (copy), LoggingProtocol (copy), LoginByUsernameSSOErrorsTelemetry (copy), Promise (copy), p11 (copy)
		local v40 = getAppFeaturePolicies().getUseSingleSignOn()
		local v41 = p6
		local v42 = p7
		local v43 = p8
		local v44 = p10
		local v45 = p12

		return ((if not getAppFeaturePolicies().getUseSingleSignOn() then LoginRequests.loginWithCode(v41, v42, v43, v44, v45) else LoginRequests.singleSignOnConnectWithCode(v41, v42, v43))):andThen(function(p14) -- line: 56
			-- upvalues: LoginResult (copy), FFlagEnableLastLoginMethodTracking (copy), AppStorageUtilities (copy), LoginMethods (copy), FFlagEnableRecordLogin (copy), recordLogin (copy)
			assert(p14, "no login attempt result")
			assert(#p14 == 1, "no result or more than one result")
			assert(LoginResult.fromJsonData(p14[1]), "result invalid")

			if FFlagEnableLastLoginMethodTracking then
				AppStorageUtilities.setLastSuccessfulSignInMethod(LoginMethods.QuickLogin)
			end

			local v47 = LoginResult.fromJsonData(p14[1])

			if FFlagEnableRecordLogin then
				pcall(function() -- line: 65
					-- upvalues: recordLogin (copy), v47 (copy), LoginMethods (copy)
					recordLogin(v47, LoginMethods.QuickLogin, v47.user.name)
				end)
			end

			return v47
		end, function(p15) -- line: 71
			-- upvalues: HttpService (copy), LoginErrorCodes (copy), GetDxBlob (copy), GetCaptchaDataJson (copy), AppPage (copy), p9 (copy), p7 (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), p13 (copy), NavigateDown (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), v24 (copy), v40 (copy), GetLoginByUsernameErrorMessage (copy), LoggingProtocol (copy), LoginByUsernameSSOErrorsTelemetry (copy), Promise (copy), p11 (copy)
			local data = HttpService:JSONDecode(p15.Body)
			local v50 = data and (data.errors and (data.errors[1] and data.errors[1].code))
			local v51 = nil
			local s1 = nil
			local v53 = data and (data.errors and (data.errors[1] and data.errors[1].userFacingMessage))

			if v50 == LoginErrorCodes.Captcha then
				GetDxBlob(data)

				local v54, v55 = GetCaptchaDataJson(data)
				local t1 = {
					detail = "",
					name = AppPage.CaptchaNative,
					extraProps = {
						captchaType = "login",
						cvalueType = "authToken",
						backNavigationDisabledWhileLoading = true,
						captchaCallback = p9,
						captchaId = v54,
						cvalue = p7,
						dxBlob = v55
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v9.down(v9.fromLegacyPage(t1))
				else
					p13:dispatch(NavigateDown(t1))
				end
			elseif GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and v50 == LoginErrorCodes.SecurityQuestions then
				s1 = "Authentication.Login.Response.SomethingWentWrong"

				if data.errors[1].fieldData then
					local data2 = HttpService:JSONDecode(data.errors[1].fieldData)

					if data2.sessionId and data2.userId then
						v51 = data2
						s1 = nil
					end
				end
			elseif v24 and v50 == LoginErrorCodes.IllegalChildAccountLinking then
				s1 = "Authentication.Login.LinkIllegalChildAccountLinking"
			end

			if v40 then
				warn("Login ErrorCode:", v50)
				s1 = GetLoginByUsernameErrorMessage(v50)

				local v58 = if not s1[1] then s1 else s1[1]

				LoggingProtocol.default:logRobloxTelemetryEvent(LoginByUsernameSSOErrorsTelemetry, nil, {
					ssoErrorCode = v50,
					msgShown = v58
				})
			end

			return Promise.reject({
				errorKey = s1,
				errorCode = v50,
				securityQuestionsData = v51,
				securityQuestionsCallback = p11,
				userFacingMessage = v53
			})
		end)
	end
end

return loginByCode
