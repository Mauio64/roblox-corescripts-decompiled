local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local HttpService = game:GetService("HttpService")
local Promise = require(AuthCommonParent.Promise)
local LoginRequests = require(AuthCommon.Http.Requests.LoginRequests)
local LoginResult = require(AuthCommon.Models.LoginResult)
local LoginErrorCodes = require(AuthCommon.Enums.LoginErrorCodes)
local LoginMethods = require(AuthCommon.Enums.LoginMethods)
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local GetMultipleUsersPerCredentialErrorData = require(AuthCommon.Utils.GetMultipleUsersPerCredentialErrorData)
local GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin = require(AuthCommonParent.SharedFlags).GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin
local GetFFlagEnableLoginAccountSelector = require(AuthCommonParent.SharedFlags).GetFFlagEnableLoginAccountSelector
local FFlagEnableLastLoginMethodTracking = require(AuthCommonParent.SharedFlags).FFlagEnableLastLoginMethodTracking
local v14 = game:DefineFastFlag("EnableIllegalChildAccountLinkingErrorMessageOnLoginByOtp", false)

local function loginByOtp(p1, p2, p3, p4, p5, p6) -- line: 23
	-- upvalues: LoginRequests (copy), LoginResult (copy), FFlagEnableLastLoginMethodTracking (copy), AppStorageUtilities (copy), LoginMethods (copy), HttpService (copy), LoginErrorCodes (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), GetFFlagEnableLoginAccountSelector (copy), GetMultipleUsersPerCredentialErrorData (copy), Promise (copy), v14 (copy)
	return function() -- line: 31
		-- upvalues: LoginRequests (copy), p1 (copy), p2 (copy), p3 (copy), p5 (copy), p6 (copy), LoginResult (copy), FFlagEnableLastLoginMethodTracking (copy), AppStorageUtilities (copy), LoginMethods (copy), HttpService (copy), LoginErrorCodes (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), GetFFlagEnableLoginAccountSelector (copy), GetMultipleUsersPerCredentialErrorData (copy), Promise (copy), v14 (copy), p4 (copy)
		return LoginRequests.logByOtp(p1, p2, p3, p5, p6):andThen(function(p7) -- line: 33
			-- upvalues: LoginResult (copy), FFlagEnableLastLoginMethodTracking (copy), AppStorageUtilities (copy), LoginMethods (copy)
			assert(p7, "no login attempt result")
			assert(#p7 == 1, "no result or more than one result")
			assert(LoginResult.fromJsonData(p7[1]), "result invalid")

			if FFlagEnableLastLoginMethodTracking then
				AppStorageUtilities.setLastSuccessfulSignInMethod(LoginMethods.EmailOtp)
			end

			return LoginResult.fromJsonData(p7[1])
		end, function(p8) -- line: 41
			-- upvalues: HttpService (copy), LoginErrorCodes (copy), GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin (copy), GetFFlagEnableLoginAccountSelector (copy), GetMultipleUsersPerCredentialErrorData (copy), Promise (copy), v14 (copy), p4 (copy)
			local data = HttpService:JSONDecode(p8.Body)
			local s1 = nil
			local code = data.errors[1].code
			local v27 = nil
			local v28 = data and (data.errors and (data.errors[1] and data.errors[1].userFacingMessage))

			if code == LoginErrorCodes.IncorrectCValueOrPassword then
				s1 = "Authentication.Login.Response.IncorrectOtpCode"
			elseif GetFFlagLuaAppUsingSecurityQuestionsForLuaLogin() and code == LoginErrorCodes.SecurityQuestions then
				s1 = "Authentication.Login.Response.SomethingWentWrong"

				if data.errors[1].fieldData then
					local data2 = HttpService:JSONDecode(data.errors[1].fieldData)

					if data2.sessionId and data2.userId then
						v27 = data2
						s1 = nil
					end
				end
			else
				if GetFFlagEnableLoginAccountSelector() and code == LoginErrorCodes.MultipleUsersPerCredential then
					local v30 = GetMultipleUsersPerCredentialErrorData(data)

					return Promise.reject({
						errorKey = s1,
						errorCode = code,
						usersData = v30
					})
				end

				if code == LoginErrorCodes.ServiceUnavailable then
					s1 = "Authentication.Login.Response.ServiceUnavailable"
				elseif v14 and code == LoginErrorCodes.IllegalChildAccountLinking then
					s1 = "Authentication.Login.LinkIllegalChildAccountLinking"
				elseif code ~= LoginErrorCodes.AccountLocked then
					s1 = "Authentication.Login.Response.UnknownErrorLoginWithDifferentMethod"
				end
			end

			return Promise.reject({
				errorKey = s1,
				errorCode = code,
				securityQuestionsData = v27,
				securityQuestionsCallback = p4,
				userFacingMessage = v28
			})
		end)
	end
end

return loginByOtp
