local parent = script.Parent.Parent

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)

local ContentSharingNetworking = require(parent.ContentSharingNetworking)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking

local config = httpRequest.config({
	requestFunction = function(p, p2, p3)
		return httpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
	end,
	postRequestFunction = function(_, _) end,
	maxRetryCount = game:DefineFastInt("CapturesCommonMaxHttpRequestRetries", 2),
	maxWaitTime = game:DefineFastInt("CapturesCommonMaxHttpRequestWaitTime", 8)
})

local config2 = RoduxNetworking.config({ keyPath = "NetworkStatus", networkImpl = config })

return {
	CapturesCommonNetworkImpl = config,
	CapturesCommonNetworking = ContentSharingNetworking.config({ roduxNetworking = config2 })
}
