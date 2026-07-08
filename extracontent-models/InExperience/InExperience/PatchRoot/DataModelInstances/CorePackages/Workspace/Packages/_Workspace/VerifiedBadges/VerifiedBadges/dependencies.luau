local Parent = script:FindFirstAncestor("VerifiedBadges").Parent
local UsersNetworking = require(Parent.UsersNetworking)
local RoduxNetworking = require(Parent.RoduxNetworking)
local HttpRequest = require(Parent.HttpRequest)
local v5 = RoduxNetworking.config({
	keyPath = "VerifiedBadges.NetworkStatus",
	networkImpl = HttpRequest.config({
		maxRetryCount = 0,
		requestFunction = HttpRequest.requestFunctions.RequestInternal
	})
})

return {
	RoduxNetworking = v5,
	FriendsNetworking = require(Parent.FriendsNetworking).config({
		roduxNetworking = v5
	}),
	UsersNetworking = UsersNetworking.config({
		roduxNetworking = v5
	})
}
