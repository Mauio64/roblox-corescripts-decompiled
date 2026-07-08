local SocialBlockingModal = script:FindFirstAncestor("SocialBlockingModal")
local SocialBlockingModalParent = SocialBlockingModal.Parent
local RoduxNetworking = require(SocialBlockingModalParent.RoduxNetworking)
local ChallengeRequestWrapper = require(SocialBlockingModalParent.GenericChallenges).Middleware.ChallengeRequestWrapper
local HttpRequest = require(SocialBlockingModalParent.HttpRequest)
local v6 = game:DefineFastInt("AddFriendsHttpRetryCount", 3)
local RODUX_KEY = require(SocialBlockingModal.Rodux.RODUX_KEY)
local v8 = HttpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 13
		-- upvalues: HttpRequest (copy)
		return HttpRequest.requestFunctions.RequestInternal(p1, p2, p3)
	end,
	maxRetryCount = v6
})

return (RoduxNetworking.config({
	keyPath = `{ RODUX_KEY }.NetworkStatus`,
	networkImpl = ChallengeRequestWrapper(v8)
}))
