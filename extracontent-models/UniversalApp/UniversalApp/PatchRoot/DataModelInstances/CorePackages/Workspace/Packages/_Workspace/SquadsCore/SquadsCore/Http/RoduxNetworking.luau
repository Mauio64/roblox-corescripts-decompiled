local Parent = script:FindFirstAncestor("SquadsCore").Parent
local HttpRequest = require(Parent.HttpRequest)
local RoduxNetworking = require(Parent.RoduxNetworking)
local v4 = require(Parent.Loggers).Logger:new("SquadsCore")
local v5 = game:DefineFastInt("SquadHttpRetryCount", 3)

return RoduxNetworking.config({
	keyPath = "Squad.NetworkStatus",
	networkImpl = HttpRequest.config({
		requestFunction = function(p1, p2, p3) -- line: 15
			-- upvalues: v4 (copy), HttpRequest (copy)
			v4:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

			return HttpRequest.requestFunctions.RequestInternal(p1, p2, p3)
		end,
		postRequestFunction = function(p4, p5) -- line: 19
			-- upvalues: v4 (copy)
			v4:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]", p5.requestMethod, p5.url, p4.StatusCode, p4.Body))
		end,
		maxRetryCount = v5
	})
})
