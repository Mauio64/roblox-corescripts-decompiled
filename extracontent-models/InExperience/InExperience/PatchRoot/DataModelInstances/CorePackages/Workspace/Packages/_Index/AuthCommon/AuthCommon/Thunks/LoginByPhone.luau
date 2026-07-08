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
local GetMultipleUsersPerCredentialErrorData = require(AuthCommon.Utils.GetMultipleUsersPerCredentialErrorData)
local LoginMethods = require(AuthCommon.Enums.LoginMethods)
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local recordLogin = require(AuthCommon.Utils.recordLogin)
local GetDxBlob = require(AuthCommon.Utils.GetDxBlob)
local GetCaptchaDataJson = require(AuthCommon.Utils.GetCaptchaDataJson)
local GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin = require(AuthCommonParent.SharedFlags).GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin
local GetFFlagEnableLoginAccountSelector = require(AuthCommonParent.SharedFlags).GetFFlagEnableLoginAccountSelector
local FFlagEnableLastLoginMethodTracking = require(AuthCommonParent.SharedFlags).FFlagEnableLastLoginMethodTracking
local FFlagEnableRecordLogin = require(AuthCommonParent.SharedFlags).FFlagEnableRecordLogin
local v22 = game:DefineFastFlag("EnableIllegalChildAccountLinkingErrorMessageOnLoginByPhone", false)

local function loginByPhone(p1, p2, p3, p4, p5, p6, p7, p8) -- line: 32
	-- upvalues: LoginRequests (copy), LoginResult (copy), FFlagEnableLastLoginMethodTracking (copy), AppStorageUtilities (copy), LoginMethods (copy), FFlagEnableRecordLogin (copy), recordLogin (copy), HttpService (copy), LoginErrorCodes (copy), GetDxBlob (copy), GetCaptchaDataJson (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), GetFFlagEnableLoginAccountSelector (copy), GetMultipleUsersPerCredentialErrorData (copy), Promise (copy), v22 (copy)
	return function(p9) -- line: 42
		-- upvalues: LoginRequests (copy), p1 (copy), p2 (copy), p3 (copy), p5 (copy), p7 (copy), p8 (copy), LoginResult (copy), FFlagEnableLastLoginMethodTracking (copy), AppStorageUtilities (copy), LoginMethods (copy), FFlagEnableRecordLogin (copy), recordLogin (copy), HttpService (copy), LoginErrorCodes (copy), GetDxBlob (copy), GetCaptchaDataJson (copy), AppPage (copy), p4 (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), GetFFlagEnableLoginAccountSelector (copy), GetMultipleUsersPerCredentialErrorData (copy), Promise (copy), v22 (copy), p6 (copy)
		return LoginRequests.logByPhone(p1, p2, p3, p5, p7, p8):andThen(function(p10) -- line: 51
			-- upvalues: LoginResult (copy), FFlagEnableLastLoginMethodTracking (copy), AppStorageUtilities (copy), LoginMethods (copy), FFlagEnableRecordLogin (copy), recordLogin (copy), p2 (copy)
			assert(p10, "no login attempt result")
			assert(#p10 == 1, "no result or more than one result")
			assert(LoginResult.fromJsonData(p10[1]), "result invalid")

			if FFlagEnableLastLoginMethodTracking then
				AppStorageUtilities.setLastSuccessfulSignInMethod(LoginMethods.Phone)
			end

			local v34 = LoginResult.fromJsonData(p10[1])

			if FFlagEnableRecordLogin then
				pcall(function() -- line: 60
					-- upvalues: recordLogin (copy), v34 (copy), LoginMethods (copy), p2 (copy)
					recordLogin(v34, LoginMethods.Phone, p2)
				end)
			end

			return v34
		end, function(p11) -- line: 65
			-- upvalues: HttpService (copy), LoginErrorCodes (copy), GetDxBlob (copy), GetCaptchaDataJson (copy), AppPage (copy), p4 (copy), p2 (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), p9 (copy), NavigateDown (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), GetFFlagEnableLoginAccountSelector (copy), GetMultipleUsersPerCredentialErrorData (copy), Promise (copy), v22 (copy), p6 (copy)
			local data = HttpService:JSONDecode(p11.Body)
			local s1 = nil
			local code = data.errors[1].code
			local v39 = nil
			local v40 = data and (data.errors and (data.errors[1] and data.errors[1].userFacingMessage))

			if code == LoginErrorCodes.IncorrectCValueOrPassword then
				s1 = "Authentication.Login.Response.IncorrectPhoneOrPassword"
			elseif code == LoginErrorCodes.Captcha then
				GetDxBlob(data)

				local v41, v42 = GetCaptchaDataJson(data)
				local t1 = {
					detail = "",
					name = AppPage.CaptchaNative,
					extraProps = {
						captchaType = "login",
						cvalueType = "phonenumber",
						backNavigationDisabledWhileLoading = true,
						captchaCallback = p4,
						captchaId = v41,
						cvalue = p2,
						dxBlob = v42
					}
				}

				if FFlagSignalsNavP3Dispatch then
					v9.down(v9.fromLegacyPage(t1))
				else
					p9:dispatch(NavigateDown(t1))
				end
			elseif GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and code == LoginErrorCodes.SecurityQuestions then
				s1 = "Authentication.Login.Response.SomethingWentWrong"

				if data.errors[1].fieldData then
					local data2 = HttpService:JSONDecode(data.errors[1].fieldData)

					if data2.sessionId and data2.userId then
						v39 = data2
						s1 = nil
					end
				end
			else
				if GetFFlagEnableLoginAccountSelector() and code == LoginErrorCodes.MultipleUsersPerCredential then
					local v45 = GetMultipleUsersPerCredentialErrorData(data)

					return Promise.reject({
						errorKey = s1,
						errorCode = code,
						usersData = v45,
						userFacingMessage = v40
					})
				end

				if code == LoginErrorCodes.ServiceUnavailable then
					s1 = "Authentication.Login.Response.ServiceUnavailable"
				elseif v22 and code == LoginErrorCodes.IllegalChildAccountLinking then
					s1 = "Authentication.Login.LinkIllegalChildAccountLinking"
				elseif code ~= LoginErrorCodes.AccountLocked then
					s1 = "Authentication.Login.Response.UnknownErrorLoginWithDifferentMethod"
				end
			end

			return Promise.reject({
				errorKey = s1,
				errorCode = code,
				securityQuestionsData = v39,
				securityQuestionsCallback = p6,
				userFacingMessage = v40
			})
		end)
	end
end

return loginByPhone
