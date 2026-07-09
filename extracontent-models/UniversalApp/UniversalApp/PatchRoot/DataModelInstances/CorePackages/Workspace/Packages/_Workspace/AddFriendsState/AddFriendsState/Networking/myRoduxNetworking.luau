local AddFriendsState = script:FindFirstAncestor("AddFriendsState")
local AddFriendsStateParent = AddFriendsState.Parent
local RoduxNetworking = require(AddFriendsStateParent.RoduxNetworking)
local ChallengeRequestWrapper = require(AddFriendsStateParent.GenericChallenges).Middleware.ChallengeRequestWrapper
local RODUX_KEY = require(AddFriendsState.RODUX_KEY)
local myHttpRequest = require(script.Parent.myHttpRequest)

return (RoduxNetworking.config({
	keyPath = `{ RODUX_KEY }.NetworkStatus`,
	networkImpl = ChallengeRequestWrapper(myHttpRequest)
}))
