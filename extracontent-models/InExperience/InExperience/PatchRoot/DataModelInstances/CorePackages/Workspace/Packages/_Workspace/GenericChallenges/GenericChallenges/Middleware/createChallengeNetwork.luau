local parent = script:FindFirstAncestor("GenericChallenges").Parent

local HttpClient = require(parent.HttpClient)
local ChallengeNetworkWrapper = require(script.Parent.ChallengeNetworkWrapper)
require(script.Parent.InterceptChallenge)

return function(p, p2)
	return ChallengeNetworkWrapper(p2 or HttpClient.withRetry(HttpClient.createRequestInternalNetwork()), p)
end
