local fFlagLuaAppDefaultHttpRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagLuaAppDefaultHttpRetry
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/HttpRequest")
local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoduxNetworking")

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Loggers").Logger
local v5 = logger.new(logger, "AppChat")

local config = RoduxNetworking.config

local config2 = HttpRequest.config
local v7 = {
	requestFunction = function(p2, p3, p4)
		v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p3, p2))
		return HttpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
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
	end,
	maxRetryCount = 0
}

local v8 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt("AppChatRoduxNetworkingHttpRetryCount", 4) else nil
v7.maxRetryCount = v8
return config({
	keyPath = "ChatAppReducer.networkStatus",
	networkImpl = config2(v7),
	killRequestWithFilteredIds = true
})
