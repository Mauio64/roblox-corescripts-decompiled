local NetworkingUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/NetworkingUsers")

local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/RoduxNetworking")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/HttpRequest")

local config = module2.config({
	keyPath = "VerifiedBadges.NetworkStatus",
	networkImpl = HttpRequest.config({
		requestFunction = HttpRequest.requestFunctions.RequestInternal,
		maxRetryCount = 0
	})
})

return {
	RoduxNetworking = config,
	FriendsNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/VerifiedBadges/NetworkingFriends").config({ roduxNetworking = config }),
	UsersNetworking = NetworkingUsers.config({ roduxNetworking = config })
}
