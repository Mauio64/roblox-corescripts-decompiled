local ParentParent = script.Parent.Parent
local LuaSocialLibrariesDeps = require(ParentParent.LuaSocialLibrariesDeps)
local ContentSharingNetworking = require(ParentParent.ContentSharingNetworking)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local v6 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 11
		-- upvalues: httpRequest (copy)
		return httpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	postRequestFunction = function(_, _) -- line: 15
	end,
	maxRetryCount = game:DefineFastInt("CapturesCommonMaxHttpRequestRetries", 2),
	maxWaitTime = game:DefineFastInt("CapturesCommonMaxHttpRequestWaitTime", 8)
})
local v7 = RoduxNetworking.config({
	keyPath = "NetworkStatus",
	networkImpl = v6
})

return {
	CapturesCommonNetworkImpl = v6,
	CapturesCommonNetworking = ContentSharingNetworking.config({
		roduxNetworking = v7
	})
}
