local HttpService = game:GetService("HttpService")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Promise")
local LoginRequests = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Http/Requests/LoginRequests")
local LoginResult = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Models/LoginResult")
local LoginErrorCodes = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginErrorCodes")
local LoginMethods = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/LoginMethods")
local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")

local fFlagEnableLastLoginMethodTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEnableLastLoginMethodTracking
local fFlagEnableRecordLogin = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEnableRecordLogin

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Loggers").Logger
local recordLogin = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/recordLogin")

local function loginByPasskey(p2, p3, p4)
	return function(p5)
		return LoginRequests.logByPasskey(p2, p3, p4):andThen(function(list)
			assert(list, "no login attempt result")
			assert(#list == 1, "no result or more than one result")
			local v5 = LoginResult.fromJsonData(list[1])
			assert(v5, "result invalid")

			if fFlagEnableLastLoginMethodTracking then
				AppStorageUtilities.setLastSuccessfulSignInMethod(LoginMethods.Passkey)
			end

			if fFlagEnableRecordLogin then
				pcall(function()
					recordLogin(v5, LoginMethods.Passkey, v5.user.name)
				end)
			end

			return v5
		end, function(p6)
			logger:error("Error logging in by passkey. Error: {}", p6.Body)
			local jsonDecode = HttpService:JSONDecode(p6.Body)
			local code = jsonDecode.errors[1].code

			local userFacingMessage = jsonDecode
				and jsonDecode.errors
				and jsonDecode.errors[1]
				and jsonDecode.errors[1].userFacingMessage

			local v5 = code == LoginErrorCodes.IncorrectCValueOrPassword
				and "Authentication.Login.Response.InvalidPasskeyCredential"
				or "Authentication.Login.Response.SomethingWentWrong"

			return Promise.reject({
				errorCode = code,
				errorKey = v5,
				userFacingMessage = userFacingMessage
			})
		end)
	end
end

return loginByPasskey
