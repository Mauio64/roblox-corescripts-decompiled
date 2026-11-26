local HttpService = game:GetService("HttpService")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Url
local consoleAuthRequestWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Http").Utils.ConsoleAuthRequestWrapper

local AppStorageUtilities = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AppStorageUtilities")
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UniversalAppPolicy").getAppFeaturePolicies

local fFlagEnableLuaAccountSwitch = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEnableLuaAccountSwitch

return {
	configuration = function(callback, p2)
		return callback(
			string.format("%sv1/users/%d/configuration", url.TWOSTEPVERIFICATION_URL, p2),
			"GET"
		)
	end,
	resend = function(callback, p2, p3)
		return callback(string.format("%sv1/twostepverification/resend", url.AUTH_URL), "POST", {
			postBody = HttpService:JSONEncode({
				username = p2,
				ticket = p3,
				actionType = "Login"
			}),
			maxRetryCount = 0
		})
	end,
	verify = function(callback, p2, p3, p4, p5)
		return callback(string.format("%sv1/twostepverification/verify", url.AUTH_URL), "POST", {
			postBody = HttpService:JSONEncode({
				username = p2,
				ticket = p3,
				code = p4,
				rememberDevice = p5,
				actionType = "Login"
			}),
			maxRetryCount = 0
		})
	end,
	login = function(callback, p2, p3, p4, p5)
		local v5 = string.format("%sv3/users/%s/two-step-verification/login", url.AUTH_URL, p2)
		local appFeaturePolicies = getAppFeaturePolicies()
		local jsonEncode = HttpService:JSONEncode({
			challengeId = p3,
			verificationToken = p4,
			rememberDevice = p5,
			accountBlob = fFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil,
			accountLinkParameters = appFeaturePolicies.getLinkingPlatform() and {
				LinkingPlatform = appFeaturePolicies.getLinkingPlatform()
			} or nil
		})

		if
			appFeaturePolicies.getUseSingleSignOn()
			and appFeaturePolicies.getLinkedAuthEndpointsEnabled()
		then
			return consoleAuthRequestWrapper(callback, v5, "POST", {
				postBody = jsonEncode,
				maxRetryCount = 0
			})
		end

		return callback(v5, "POST", { postBody = jsonEncode, maxRetryCount = 0 })
	end
}
