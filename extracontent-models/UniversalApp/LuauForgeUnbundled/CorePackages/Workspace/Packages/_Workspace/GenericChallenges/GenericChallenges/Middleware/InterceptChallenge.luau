local RenderChallenge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/RenderChallenge")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/InitializeHybridCallback")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/LuauPolyfill")

return function(data)
	return Promise.new(function(p2, p3)
		RenderChallenge({
			title = data.title,
			rawResponseHeaders = data.rawResponseHeaders,
			retryRequestCallback = data.retryRequestCallback,
			challengeErrorCallback = data.challengeErrorCallback,
			resolve = p2,
			reject = p3
		})
	end)
end
