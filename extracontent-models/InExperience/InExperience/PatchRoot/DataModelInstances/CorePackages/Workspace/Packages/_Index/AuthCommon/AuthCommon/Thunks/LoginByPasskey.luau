local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local HttpService = game:GetService("HttpService")
local Promise = require(parent.Promise)
local LoginRequests = require(AuthCommon.Http.Requests.LoginRequests)
local LoginResult = require(AuthCommon.Models.LoginResult)
local LoginErrorCodes = require(AuthCommon.Enums.LoginErrorCodes)
local LoginMethods = require(AuthCommon.Enums.LoginMethods)
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableLastLoginMethodTracking = SharedFlags.FFlagEnableLastLoginMethodTracking
local SharedFlags2 = require(parent.SharedFlags)
local FFlagEnableRecordLogin = SharedFlags2.FFlagEnableRecordLogin

local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger
local recordLogin = require(AuthCommon.Utils.recordLogin)

local function loginByPasskey(p, p2, p3)
	return function(_)
		return LoginRequests.logByPasskey(p, p2, p3):andThen(function(list)
			assert(list, "no login attempt result")
			assert(#list == 1, "no result or more than one result")
			local v = LoginResult.fromJsonData(list[1])
			assert(v, "result invalid")

			if FFlagEnableLastLoginMethodTracking then
				AppStorageUtilities.setLastSuccessfulSignInMethod(LoginMethods.Passkey)
			end

			if FFlagEnableRecordLogin then
				pcall(function()
					recordLogin(v, LoginMethods.Passkey, v.user.name)
				end)
			end

			return v
		end, function(p4)
			Logger:error("Error logging in by passkey. Error: {}", p4.Body)
			local jsonDecode = HttpService:JSONDecode(p4.Body)
			local code = jsonDecode.errors[1].code

			local userFacingMessage = jsonDecode
				and jsonDecode.errors
				and jsonDecode.errors[1]
				and jsonDecode.errors[1].userFacingMessage

			local errorKey = code == LoginErrorCodes.IncorrectCValueOrPassword
				and "Authentication.Login.Response.InvalidPasskeyCredential"
				or "Authentication.Login.Response.SomethingWentWrong"

			return Promise.reject({
				errorCode = code,
				errorKey = errorKey,
				userFacingMessage = userFacingMessage
			})
		end)
	end
end

return loginByPasskey
