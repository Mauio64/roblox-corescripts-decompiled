local parent = script:FindFirstAncestor("SquadsCore").Parent

local HttpRequest = require(parent.HttpRequest)
local RoduxNetworking = require(parent.RoduxNetworking)

local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger
local v = Logger.new(Logger, "SquadsCore")

local defineFastInt = game:DefineFastInt("SquadHttpRetryCount", 3)

return RoduxNetworking.config({
	keyPath = "Squad.NetworkStatus",
	networkImpl = HttpRequest.config({
		requestFunction = function(p, p2, p3)
			v:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p))
			return HttpRequest.requestFunctions.RequestInternal(p, p2, p3)
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
})
