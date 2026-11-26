local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/LuaSocialLibrariesDeps")
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local roduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Common/Constants").RODUX_KEY
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/Lumberyak").Logger.new(nil, "ProfileShareLinks"):new("ProfileShareLinks Networking")
local defineFastInt = game:DefineFastInt("ProfileShareLinksHttpRetryCount", 3)

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

return (roduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = config
}))
