local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local HttpService = game:GetService("HttpService")
local Http = require(parent.Http)
local Url = Http.Url
local Http2 = require(parent.Http)
local ConsoleAuthRequestWrapper = Http2.Utils.ConsoleAuthRequestWrapper

local AppStorageUtilities = require(AuthCommon.Utils.AppStorageUtilities)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableLuaAccountSwitch = SharedFlags.FFlagEnableLuaAccountSwitch
local TwoStepRequests = {}

function TwoStepRequests.configuration(callback, p: number)
	return callback(string.format("%sv1/users/%d/configuration", Url.TWOSTEPVERIFICATION_URL, p), "GET")
end

function TwoStepRequests.resend(callback, username, ticket)
	return callback(string.format("%sv1/twostepverification/resend", Url.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({
			username = username,
			ticket = ticket,
			actionType = "Login"
		}),
		maxRetryCount = 0
	})
end

function TwoStepRequests.verify(callback, username, ticket, code, rememberDevice)
	return callback(string.format("%sv1/twostepverification/verify", Url.AUTH_URL), "POST", {
		postBody = HttpService:JSONEncode({
			username = username,
			ticket = ticket,
			code = code,
			rememberDevice = rememberDevice,
			actionType = "Login"
		}),
		maxRetryCount = 0
	})
end

function TwoStepRequests.login(callback, p, challengeId, verificationToken, rememberDevice)
	local v = string.format("%sv3/users/%s/two-step-verification/login", Url.AUTH_URL, p)
	local appFeaturePolicies = getAppFeaturePolicies()
	local jsonEncode = HttpService:JSONEncode({
		challengeId = challengeId,
		verificationToken = verificationToken,
		rememberDevice = rememberDevice,
		accountBlob = FFlagEnableLuaAccountSwitch and AppStorageUtilities.getAccountBlob() or nil,
		accountLinkParameters = appFeaturePolicies.getLinkingPlatform() and {
			LinkingPlatform = appFeaturePolicies.getLinkingPlatform()
		} or nil
	})

	if appFeaturePolicies.getUseSingleSignOn() and appFeaturePolicies.getLinkedAuthEndpointsEnabled() then
		return ConsoleAuthRequestWrapper(callback, v, "POST", {
			postBody = jsonEncode,
			maxRetryCount = 0
		})
	end

	return callback(v, "POST", { postBody = jsonEncode, maxRetryCount = 0 })
end

return TwoStepRequests
