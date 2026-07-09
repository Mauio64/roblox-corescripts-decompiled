local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local HttpService = game:GetService("HttpService")
local Promise = require(AuthCommonParent.Promise)
local LoginRequests = require(AuthCommon.Http.Requests.LoginRequests)
local LoginResult = require(AuthCommon.Models.LoginResult)
local LoginErrorCodes = require(AuthCommon.Enums.LoginErrorCodes)
local LoginMethods = require(AuthCommon.Enums.LoginMethods)
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local FFlagEnableLastLoginMethodTracking = require(AuthCommonParent.SharedFlags).FFlagEnableLastLoginMethodTracking
local FFlagEnableRecordLogin = require(AuthCommonParent.SharedFlags).FFlagEnableRecordLogin
local Logger = require(AuthCommonParent.Loggers).Logger
local recordLogin = require(AuthCommon.Utils.recordLogin)

local function loginByPasskey(p1, p2, p3) -- line: 19
	-- upvalues: LoginRequests (copy), LoginResult (copy), FFlagEnableLastLoginMethodTracking (copy), AppStorageUtilities (copy), LoginMethods (copy), FFlagEnableRecordLogin (copy), recordLogin (copy), Logger (copy), HttpService (copy), LoginErrorCodes (copy), Promise (copy)
	return function(_) -- line: 20
		-- upvalues: LoginRequests (copy), p1 (copy), p2 (copy), p3 (copy), LoginResult (copy), FFlagEnableLastLoginMethodTracking (copy), AppStorageUtilities (copy), LoginMethods (copy), FFlagEnableRecordLogin (copy), recordLogin (copy), Logger (copy), HttpService (copy), LoginErrorCodes (copy), Promise (copy)
		return LoginRequests.logByPasskey(p1, p2, p3):andThen(function(p5) -- line: 21
			-- upvalues: LoginResult (copy), FFlagEnableLastLoginMethodTracking (copy), AppStorageUtilities (copy), LoginMethods (copy), FFlagEnableRecordLogin (copy), recordLogin (copy)
			assert(p5, "no login attempt result")
			assert(#p5 == 1, "no result or more than one result")

			local v20 = LoginResult.fromJsonData(p5[1])

			assert(v20, "result invalid")

			if FFlagEnableLastLoginMethodTracking then
				AppStorageUtilities.setLastSuccessfulSignInMethod(LoginMethods.Passkey)
			end

			if FFlagEnableRecordLogin then
				pcall(function() -- line: 30
					-- upvalues: recordLogin (copy), v20 (copy), LoginMethods (copy)
					recordLogin(v20, LoginMethods.Passkey, v20.user.name)
				end)
			end

			return v20
		end, function(p6) -- line: 36
			-- upvalues: Logger (copy), HttpService (copy), LoginErrorCodes (copy), Promise (copy)
			Logger:error("Error logging in by passkey. Error: {}", p6.Body)

			local data = HttpService:JSONDecode(p6.Body)
			local code = data.errors[1].code
			local s1 = "Authentication.Login.Response.SomethingWentWrong"
			local v25 = data and (data.errors and (data.errors[1] and data.errors[1].userFacingMessage))

			if code == LoginErrorCodes.IncorrectCValueOrPassword then
				s1 = "Authentication.Login.Response.InvalidPasskeyCredential"
			end

			return Promise.reject({
				errorCode = code,
				errorKey = s1,
				userFacingMessage = v25
			})
		end)
	end
end

return loginByPasskey
