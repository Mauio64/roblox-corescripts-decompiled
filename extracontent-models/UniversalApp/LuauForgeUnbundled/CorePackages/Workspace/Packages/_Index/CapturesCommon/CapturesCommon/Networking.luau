local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/LuaSocialLibrariesDeps")

local ContentSharingNetworking = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/ContentSharingNetworking")
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local roduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking

local config = httpRequest.config({
	requestFunction = function(p2, p3, p4)
		return httpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
	end,
	postRequestFunction = function(p2, p3) end,
	maxRetryCount = game:DefineFastInt("CapturesCommonMaxHttpRequestRetries", 2),
	maxWaitTime = game:DefineFastInt("CapturesCommonMaxHttpRequestWaitTime", 8)
})

local config2 = roduxNetworking.config({
	keyPath = "NetworkStatus",
	networkImpl = config
})

return {
	CapturesCommonNetworkImpl = config,
	CapturesCommonNetworking = ContentSharingNetworking.config({ roduxNetworking = config2 })
}
