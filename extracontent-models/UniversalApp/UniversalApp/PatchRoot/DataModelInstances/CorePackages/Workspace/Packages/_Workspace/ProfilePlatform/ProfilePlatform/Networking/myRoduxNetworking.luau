local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local LuaSocialLibrariesDeps = require(ProfilePlatformParent.LuaSocialLibrariesDeps)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local RODUX_KEY = require(ProfilePlatform.Common.Constants).RODUX_KEY
local v6 = require(ProfilePlatformParent.Lumberyak).Logger.new(nil, RODUX_KEY):new(RODUX_KEY .. " Networking")
local v7 = game:DefineFastInt("ProfilePlatformHttpRetryCount", 3)
local ChallengeRequestWrapper = require(ProfilePlatformParent.GenericChallenges).Middleware.ChallengeRequestWrapper
local v9 = game:DefineFastFlag("EnableProfilePlatformChallengeInterceptor", false)
local FFlagProfilePlatformUseRoduxNetworkingRefactor = require(ProfilePlatform.Flags.FFlagProfilePlatformUseRoduxNetworkingRefactor)
local myRoduxNetworkingImpl = require(ProfilePlatform.Networking.myRoduxNetworkingImpl)
local v12 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 22
		-- upvalues: v6 (copy), httpRequest (copy)
		v6:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		return httpRequest.requestFunctions.RequestInternal(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 26
		-- upvalues: v6 (copy)
		v6:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]", p5.requestMethod, p5.url, p4.StatusCode, p4.Body))
	end,
	maxRetryCount = v7
})
local v13 = if not FFlagProfilePlatformUseRoduxNetworkingRefactor then v12 else myRoduxNetworkingImpl

return (LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = v9 and ChallengeRequestWrapper(v13) or v13
}))
