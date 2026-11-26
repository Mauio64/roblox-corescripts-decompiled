local CorePackages = game:GetService("CorePackages")
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local defineFastInt = game:DefineFastInt("EventNetworkHttpRetryCount", 3)
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/cip")
local NetworkingFriends = require("@game/CorePackages/Workspace/Packages/NetworkingFriends")
local NetworkingShareLinks = require("@game/CorePackages/Workspace/Packages/NetworkingShareLinks")

local config = httpRequest.config({
	requestFunction = function(p2, p3, p4)
		return httpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
	end,
	maxRetryCount = defineFastInt
})

local config2 = LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = "EventReceievers.NetworkStatus",
	networkImpl = config
})

local config3 = NetworkingFriends.config({ roduxNetworking = config2 })

local config4 = LuaSocialLibrariesDeps.NetworkingPresence.config({
	roduxNetworking = config2
})

local config5 = NetworkingShareLinks.config({ roduxNetworking = config2, useMockedResponse = false })

return {
	networkImpl = config,
	RoduxNetworking = config2,
	installReducer = function()
		return Rodux.combineReducers({ NetworkStatus = config2.installReducer() })
	end,
	FriendsNetworking = config3,
	NetworkingPresence = config4,
	RoduxFriends = module.config({ keyPath = "EventReceievers.Friends" }),
	RoduxUsers = LuaSocialLibrariesDeps.RoduxUsers.config({
		keyPath = "EventReceievers.Users"
	}),
	RoduxPresence = LuaSocialLibrariesDeps.RoduxPresence.config({
		keyPath = "EventReceievers.Presence"
	}),
	RoduxKey = "EventReceievers",
	ShareLinksNetworking = config5
}
