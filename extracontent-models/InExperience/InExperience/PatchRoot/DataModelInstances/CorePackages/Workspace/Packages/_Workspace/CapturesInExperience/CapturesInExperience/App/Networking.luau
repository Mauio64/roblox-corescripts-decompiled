local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuaSocialLibrariesDeps = require(ParentParentParent.LuaSocialLibrariesDeps)
local Lumberyak = require(ParentParentParent.Lumberyak)
local ContentSharingNetworking = require(ParentParentParent.ContentSharingNetworking)
local ShareLinksNetworking = require(ParentParentParent.ShareLinksNetworking)
local ShareLinksRodux = require(ParentParentParent.ShareLinksRodux)
local FFlagCreateMomentsToast = require(ParentParent.Flags.FFlagCreateMomentsToast)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local Constants = require(ParentParent.Constants)
local v12 = Lumberyak.Logger.new(nil, Constants.LoggerKey)
local v13 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 19
		-- upvalues: v12 (copy), httpRequest (copy)
		v12:debug(`Request: [ requestMethod = { p2 }, url = { p1 } ]`)

		return httpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	maxRetryCount = game:DefineFastInt("CapturesMaxHttpRequestRetries", 2),
	maxWaitTime = game:DefineFastInt("CapturesMaxHttpRequestWaitTime", 8)
})
local v14 = RoduxNetworking.config({
	keyPath = "NetworkStatus",
	networkImpl = v13
})

return {
	RoduxNetworking = v14,
	ContentSharingNetworking = if not FFlagCreateMomentsToast then nil else ContentSharingNetworking.config({
		roduxNetworking = v14
	}),
	ShareLinksNetworking = ShareLinksNetworking.config({
		roduxNetworking = v14
	}),
	ShareLinksRodux = ShareLinksRodux.config({
		keyPath = "ShareLinks"
	})
}
