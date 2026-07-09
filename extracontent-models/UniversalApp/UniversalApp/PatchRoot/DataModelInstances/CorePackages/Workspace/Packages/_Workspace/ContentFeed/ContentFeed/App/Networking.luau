local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local LuaSocialLibrariesDeps = require(ParentParentParent.LuaSocialLibrariesDeps)
local Lumberyak = require(ParentParentParent.Lumberyak)
local ContentSharingNetworking = require(ParentParentParent.ContentSharingNetworking)
local ContentSharingRodux = require(ParentParentParent.ContentSharingRodux)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local NetworkingCurrentlyWearing = LuaSocialLibrariesDeps.NetworkingCurrentlyWearing
local NetworkingGames = require(ParentParentParent.NetworkingGames)
local NetworkingUsers = require(ParentParentParent.NetworkingUsers)
local RoduxGames = require(ParentParentParent.RoduxGames)
local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local RoduxUsers = require(ParentParentParent.RoduxUsers)
local ShareLinksNetworking = require(ParentParentParent.ShareLinksNetworking)
local ShareLinksRodux = require(ParentParentParent.ShareLinksRodux)
local Constants = require(ParentParent.Constants)
local v17 = Lumberyak.Logger.new(nil, Constants.LoggerKey)
local v18 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 24
		-- upvalues: v17 (copy), httpRequest (copy)
		v17:debug(`Request: [ requestMethod = { p2 }, url = { p1 } ]`)

		return httpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 29
		-- upvalues: v17 (copy)
		v17:debug(`Response: [ requestMethod = { p5.requestMethod }, url = { p5.url }, statusCode = { p4.StatusCode }, body = { p4.Body } ]`)
	end,
	maxRetryCount = game:DefineFastInt("ContentFeedMaxHttpRequestRetries", 2),
	maxWaitTime = game:DefineFastInt("ContentFeedMaxHttpRequestWaitTime", 8)
})
local v19 = RoduxNetworking.config({
	keyPath = "NetworkStatus",
	networkImpl = v18
})

return {
	ContentFeedNetworkImpl = v18,
	ContentSharingNetworking = ContentSharingNetworking.config({
		roduxNetworking = v19
	}),
	ContentSharingRodux = ContentSharingRodux.config({
		keyPath = "ContentSharing"
	}),
	NetworkingCurrentlyWearing = NetworkingCurrentlyWearing.config({
		roduxNetworking = v19
	}),
	NetworkingGames = NetworkingGames.config({
		roduxNetworking = v19
	}),
	NetworkingUsers = NetworkingUsers.config({
		roduxNetworking = v19
	}),
	RoduxGames = RoduxGames.config({
		keyPath = "Games"
	}),
	RoduxNetworking = v19,
	RoduxUsers = RoduxUsers.config({
		keyPath = "Users"
	}),
	ShareLinksNetworking = ShareLinksNetworking.config({
		roduxNetworking = v19
	}),
	ShareLinksRodux = ShareLinksRodux.config({
		keyPath = "ShareLinks"
	})
}
