local CorePackages = game:GetService("CorePackages")
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local Lumberyak = require(CorePackages.Packages.Lumberyak)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local v5 = Lumberyak.Logger.new(nil, "ContactList")
local v6 = game:DefineFastInt("ContactListHttpRetryCount", 3)
local v7 = v5:new("ContactList Networking")
local v8 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 10
		-- upvalues: v7 (copy), httpRequest (copy)
		v7:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		return httpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 14
		-- upvalues: v7 (copy)
		v7:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]", p5.requestMethod, p5.url, p4.StatusCode, p4.Body))
	end,
	maxRetryCount = v6
})
local v9 = LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = "NetworkStatus",
	networkImpl = v8
})

return {
	Hooks = {
		dependencyArray = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.dependencyArray,
		useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch,
		useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector,
		usePrevious = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.usePrevious,
		useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
	},
	NetworkingCall = LuaSocialLibrariesDeps.NetworkingCall.config({
		useMockedResponse = true,
		roduxNetworking = v9
	}),
	RoduxCall = LuaSocialLibrariesDeps.RoduxCall.config({
		keyPath = "Call"
	}),
	RoduxFriends = require(CorePackages.Workspace.Packages.FriendsRodux).config({
		keyPath = "Friends"
	}),
	RoduxPresence = LuaSocialLibrariesDeps.RoduxPresence.config({
		keyPath = "Presence"
	}),
	RoduxUsers = LuaSocialLibrariesDeps.RoduxUsers.config({
		keyPath = "Users"
	}),
	RoduxNetworking = v9,
	NetworkingPresence = LuaSocialLibrariesDeps.NetworkingPresence.config({
		roduxNetworking = v9
	}),
	NetworkingFriends = require(CorePackages.Workspace.Packages.FriendsNetworking).config({
		roduxNetworking = v9
	}),
	NetworkingUsers = LuaSocialLibrariesDeps.NetworkingUsers.config({
		roduxNetworking = v9
	}),
	SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({}),
	UIBlox = require(CorePackages.Packages.UIBlox),
	Foundation = require(CorePackages.Packages.Foundation),
	enumerate = require(CorePackages.Packages.enumerate),
	getStandardSizeAvatarHeadShotRbxthumb = require(CorePackages.Workspace.Packages.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb,
	teleportToRootPlace = require(script.Parent.teleportToRootPlace)
}
