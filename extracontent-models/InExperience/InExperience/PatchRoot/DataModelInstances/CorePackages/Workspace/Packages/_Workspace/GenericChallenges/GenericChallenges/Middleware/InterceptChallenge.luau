local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local RenderChallenge = require(script.Parent.RenderChallenge)
require(script.Parent.InitializeHybridCallback)

local parent = GenericChallenges.Parent
local Promise = require(parent.Promise)
require(parent.LuauPolyfill)

return function(data)
	return Promise.new(function(resolve, reject)
		RenderChallenge({
			title = data.title,
			rawResponseHeaders = data.rawResponseHeaders,
			retryRequestCallback = data.retryRequestCallback,
			challengeErrorCallback = data.challengeErrorCallback,
			resolve = resolve,
			reject = reject
		})
	end)
end
