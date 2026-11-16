local parent = script:FindFirstAncestor("AppChat").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDefaultHttpRetry = SharedFlags.FFlagLuaAppDefaultHttpRetry
local HttpRequest = require(parent.HttpRequest)
local RoduxNetworking = require(parent.RoduxNetworking)

local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger
local v = Logger.new(Logger, "AppChat")

local config = RoduxNetworking.config

local config2 = HttpRequest.config
local v2 = {
	requestFunction = function(p, p2, p3)
		v:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p))
		return HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
	end,
	postRequestFunction = function(p, p2)
		v:debug(
			"Returned: {}",
			string.format("[ requestMethod = %q, url = %q, statusCode = %s ]", p2.requestMethod, p2.url, p.StatusCode)
		)
	end,
	maxRetryCount = 0
}
local maxRetryCount

if FFlagLuaAppDefaultHttpRetry then
	maxRetryCount = game:DefineFastInt("AppChatRoduxNetworkingHttpRetryCount", 4)
end

v2.maxRetryCount = maxRetryCount
return config({
	keyPath = "ChatAppReducer.networkStatus",
	networkImpl = config2(v2),
	killRequestWithFilteredIds = true
})
