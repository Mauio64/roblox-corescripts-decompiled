local SocialBlockingModal = script:FindFirstAncestor("SocialBlockingModal")
local parent = SocialBlockingModal.Parent

local RoduxNetworking = require(parent.RoduxNetworking)
local GenericChallenges = require(parent.GenericChallenges)
local ChallengeRequestWrapper = GenericChallenges.Middleware.ChallengeRequestWrapper

local HttpRequest = require(parent.HttpRequest)
local defineFastInt = game:DefineFastInt("AddFriendsHttpRetryCount", 3)

local RODUX_KEY = require(SocialBlockingModal.Rodux.RODUX_KEY)

local config = HttpRequest.config({
	requestFunction = function(p, p2, p3)
		return HttpRequest.requestFunctions.RequestInternal(p, p2, p3)
	end,
	maxRetryCount = defineFastInt
})

return (RoduxNetworking.config({
	keyPath = `{RODUX_KEY}.NetworkStatus`,
	networkImpl = ChallengeRequestWrapper(config)
}))
