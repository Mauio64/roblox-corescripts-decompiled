local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/HttpRequest")
local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/RoduxNetworking")
local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/SocialProof/SocialProof/Common/Constants").RODUX_KEY
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialProof/Lumberyak").Logger.new(nil, RODUX_KEY):new(RODUX_KEY .. " Networking")

return (RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = HttpRequest.config({
		requestFunction = function(p2, p3, p4)
			v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p3, p2))
			return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
		end,
		postRequestFunction = function(p2, p3)
			v5:debug(
				"Returned: {}",
				string.format(
					"[ requestMethod = %q, url = %q, statusCode = %s ]",
					p3.requestMethod,
					p3.url,
					p2.StatusCode
				)
			)
		end
	})
}))
