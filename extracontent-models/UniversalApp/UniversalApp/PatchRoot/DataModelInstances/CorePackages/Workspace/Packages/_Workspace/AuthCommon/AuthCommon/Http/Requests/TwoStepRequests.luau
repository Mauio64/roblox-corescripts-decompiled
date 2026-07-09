local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local HttpService = game:GetService("HttpService")
local Url = require(AuthCommonParent.Http).Url
local ConsoleAuthRequestWrapper = require(AuthCommonParent.Http).Utils.ConsoleAuthRequestWrapper
local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local getAppFeaturePolicies = require(AuthCommonParent.UniversalAppPolicy).getAppFeaturePolicies
local FFlagEnableLuaAccountSwitch = require(AuthCommonParent.SharedFlags).FFlagEnableLuaAccountSwitch

return {
	configuration = function(p1, n1: number) -- line: 24
		-- upvalues: Url (copy)
		return p1(string.format("%sv1/users/%d/configuration", Url.TWOSTEPVERIFICATION_URL, n1), "GET")
	end,
	resend = function(p2, p3, p4) -- line: 30
		-- upvalues: Url (copy), HttpService (copy)
		local v14 = string.format("%sv1/twostepverification/resend", Url.AUTH_URL)
		local json = HttpService:JSONEncode({
			actionType = "Login",
			username = p3,
			ticket = p4
		})

		return p2(v14, "POST", {
			maxRetryCount = 0,
			postBody = json
		})
	end,
	verify = function(p5, p6, p7, p8, p9) -- line: 41
		-- upvalues: Url (copy), HttpService (copy)
		local v21 = string.format("%sv1/twostepverification/verify", Url.AUTH_URL)
		local json = HttpService:JSONEncode({
			actionType = "Login",
			username = p6,
			ticket = p7,
			code = p8,
			rememberDevice = p9
		})

		return p5(v21, "POST", {
			maxRetryCount = 0,
			postBody = json
		})
	end,
	login = function(p10, p11, p12, p13, p14) -- line: 54
		-- upvalues: Url (copy), getAppFeaturePolicies (copy), HttpService (copy), FFlagEnableLuaAccountSwitch (copy), AppStorageUtilities (copy), ConsoleAuthRequestWrapper (copy)
		local v28 = string.format("%sv3/users/%s/two-step-verification/login", Url.AUTH_URL, p11)
		local v29 = getAppFeaturePolicies()
		local json = HttpService:JSONEncode({
			challengeId = p12,
			verificationToken = p13,
			rememberDevice = p14,
			accountBlob = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil,
			accountLinkParameters = if not v29.getLinkingPlatform() then nil else {
				LinkingPlatform = v29.getLinkingPlatform()
			}
		})

		if v29.getUseSingleSignOn() and v29.getLinkedAuthEndpointsEnabled() then
			return ConsoleAuthRequestWrapper(p10, v28, "POST", {
				maxRetryCount = 0,
				postBody = json
			})
		end

		return p10(v28, "POST", {
			maxRetryCount = 0,
			postBody = json
		})
	end
}
