local CorePackages = game:GetService("CorePackages")
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local v4 = game:DefineFastInt("EventNetworkHttpRetryCount", 3)
local Rodux = require(CorePackages.Packages.Rodux)
local FriendsRodux = require(CorePackages.Workspace.Packages.FriendsRodux)
local FriendsNetworking = require(CorePackages.Workspace.Packages.FriendsNetworking)
local ShareLinksNetworking = require(CorePackages.Workspace.Packages.ShareLinksNetworking)
local v9 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 11
		-- upvalues: httpRequest (copy)
		return httpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	maxRetryCount = v4
})
local v10 = LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = "EventReceievers.NetworkStatus",
	networkImpl = v9
})
local v11 = FriendsNetworking.config({
	roduxNetworking = v10
})
local v12 = LuaSocialLibrariesDeps.NetworkingPresence.config({
	roduxNetworking = v10
})
local v13 = ShareLinksNetworking.config({
	useMockedResponse = false,
	roduxNetworking = v10
})

return {
	RoduxKey = "EventReceievers",
	networkImpl = v9,
	RoduxNetworking = v10,
	installReducer = function() -- line: 37
		-- upvalues: Rodux (copy), v10 (copy)
		return Rodux.combineReducers({
			NetworkStatus = v10.installReducer()
		})
	end,
	FriendsNetworking = v11,
	NetworkingPresence = v12,
	RoduxFriends = FriendsRodux.config({
		keyPath = "EventReceievers.Friends"
	}),
	RoduxUsers = LuaSocialLibrariesDeps.RoduxUsers.config({
		keyPath = "EventReceievers.Users"
	}),
	RoduxPresence = LuaSocialLibrariesDeps.RoduxPresence.config({
		keyPath = "EventReceievers.Presence"
	}),
	ShareLinksNetworking = v13
}
