local Parent = script:FindFirstAncestor("AppChat").Parent
local FFlagLuaAppDefaultHttpRetry = require(Parent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local HttpRequest = require(Parent.HttpRequest)
local RoduxNetworking = require(Parent.RoduxNetworking)
local v5 = require(Parent.Loggers).Logger:new("AppChat")

return RoduxNetworking.config({
	keyPath = "ChatAppReducer.networkStatus",
	killRequestWithFilteredIds = true,
	networkImpl = HttpRequest.config({
		requestFunction = function(p1, p2, p3) -- line: 14
			-- upvalues: v5 (copy), HttpRequest (copy)
			v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

			return HttpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
		end,
		postRequestFunction = function(p4, p5) -- line: 18
			-- upvalues: v5 (copy)
			v5:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s ]", p5.requestMethod, p5.url, p4.StatusCode))
		end,
		maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("AppChatRoduxNetworkingHttpRetryCount", 4)
	})
})
