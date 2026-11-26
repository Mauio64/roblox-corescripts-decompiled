local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/HttpRequest")
local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoduxNetworking")

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Loggers").Logger
local v5 = logger.new(logger, "SquadsCore")

local defineFastInt = game:DefineFastInt("SquadHttpRetryCount", 3)

return RoduxNetworking.config({
	keyPath = "Squad.NetworkStatus",
	networkImpl = HttpRequest.config({
		requestFunction = function(p2, p3, p4)
			v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p3, p2))
			return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
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
})
