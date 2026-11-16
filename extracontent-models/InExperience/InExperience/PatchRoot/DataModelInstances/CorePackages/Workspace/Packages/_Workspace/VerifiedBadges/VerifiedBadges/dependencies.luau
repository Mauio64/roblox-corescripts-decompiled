local parent = script:FindFirstAncestor("VerifiedBadges").Parent

local UsersNetworking = require(parent.UsersNetworking)

local RoduxNetworking = require(parent.RoduxNetworking)
local HttpRequest = require(parent.HttpRequest)

local config = RoduxNetworking.config({
	keyPath = "VerifiedBadges.NetworkStatus",
	networkImpl = HttpRequest.config({
		requestFunction = HttpRequest.requestFunctions.RequestInternal,
		maxRetryCount = 0
	})
})

local FriendsNetworking = require(parent.FriendsNetworking)
return {
	RoduxNetworking = config,
	FriendsNetworking = FriendsNetworking.config({ roduxNetworking = config }),
	UsersNetworking = UsersNetworking.config({ roduxNetworking = config })
}
