local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local Constants = require(ProfilePlatform.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY
local Lumberyak = require(parent.Lumberyak)

local v = Lumberyak.Logger.new(nil, RODUX_KEY):new(RODUX_KEY .. " Networking")
local defineFastInt = game:DefineFastInt("ProfilePlatformHttpRetryCount", 3)

local GenericChallenges = require(parent.GenericChallenges)
local ChallengeRequestWrapper = GenericChallenges.Middleware.ChallengeRequestWrapper

local defineFastFlag = game:DefineFastFlag("EnableProfilePlatformChallengeInterceptor", false)

local FFlagProfilePlatformUseRoduxNetworkingRefactor = require(ProfilePlatform.Flags.FFlagProfilePlatformUseRoduxNetworkingRefactor)

local networkImpl = require(ProfilePlatform.Networking.myRoduxNetworkingImpl)

local config = httpRequest.config({
	requestFunction = function(p, p2, p3)
		v:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p))
		return httpRequest.requestFunctions.RequestInternal(p, p2, p3)
	end,
	postRequestFunction = function(p, p2)
		v:debug(
			"Returned: {}",
			string.format(
				"[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]",
				p2.requestMethod,
				p2.url,
				p.StatusCode,
				p.Body
			)
		)
	end,
	maxRetryCount = defineFastInt
})

local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking

if not FFlagProfilePlatformUseRoduxNetworkingRefactor then
	networkImpl = config
end

local config2 = RoduxNetworking.config
local v2 = {
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = 0
}
networkImpl = defineFastFlag and ChallengeRequestWrapper(networkImpl) or networkImpl
v2.networkImpl = networkImpl
return (config2(v2))
