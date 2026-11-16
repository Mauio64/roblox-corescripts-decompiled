local RoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/RoduxNetworking")
local challengeRequestWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/GenericChallenges").Middleware.ChallengeRequestWrapper

local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialBlockingModal/HttpRequest")
local defineFastInt = game:DefineFastInt("AddFriendsHttpRetryCount", 3)

local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/SocialBlockingModal/SocialBlockingModal/Rodux/RODUX_KEY")

local config = HttpRequest.config({
	requestFunction = function(p2, p3, p4)
		return HttpRequest.requestFunctions.RequestInternal(p2, p3, p4)
	end,
	maxRetryCount = defineFastInt
})

return (RoduxNetworking.config({
	keyPath = `{module3}.NetworkStatus`,
	networkImpl = challengeRequestWrapper(config)
}))
