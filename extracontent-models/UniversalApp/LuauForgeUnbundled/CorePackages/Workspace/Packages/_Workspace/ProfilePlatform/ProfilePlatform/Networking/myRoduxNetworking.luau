local module = require("@luauforge/bundled/eUd")
local httpRequest = module.httpRequest
local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants").RODUX_KEY
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Lumberyak").Logger.new(nil, RODUX_KEY):new(RODUX_KEY .. " Networking")
local defineFastInt = game:DefineFastInt("ProfilePlatformHttpRetryCount", 3)

local challengeRequestWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GenericChallenges").Middleware.ChallengeRequestWrapper

local defineFastFlag = game:DefineFastFlag("EnableProfilePlatformChallengeInterceptor", false)

local FFlagProfilePlatformUseRoduxNetworkingRefactor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformUseRoduxNetworkingRefactor")

local v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myRoduxNetworkingImpl")

local config = httpRequest.config({
	requestFunction = function(p2, p3, p4)
		v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p3, p2))
		return httpRequest.requestFunctions.RequestInternal(p2, p3, p4)
	end,
	postRequestFunction = function(p2, p3)
		v5:debug(
			"Returned: {}",
			string.format(
				"[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]",
				p3.requestMethod,
				p3.url,
				p2.StatusCode,
				p2.Body
			)
		)
	end,
	maxRetryCount = defineFastInt
})

local roduxNetworking = module.RoduxNetworking

if not FFlagProfilePlatformUseRoduxNetworkingRefactor then
	v6 = config
end

local config2 = roduxNetworking.config
local v7 = {
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = 0
}
v6 = defineFastFlag and challengeRequestWrapper(v6) or v6
v7.networkImpl = v6
return (config2(v7))
