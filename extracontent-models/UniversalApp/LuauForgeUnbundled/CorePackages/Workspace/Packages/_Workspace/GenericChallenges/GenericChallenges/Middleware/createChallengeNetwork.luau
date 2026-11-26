local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/HttpClient")
local ChallengeNetworkWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/ChallengeNetworkWrapper")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/InterceptChallenge")

return function(p2, p3)
	return ChallengeNetworkWrapper(p3 or HttpClient.withRetry(HttpClient.createRequestInternalNetwork()), p2)
end
