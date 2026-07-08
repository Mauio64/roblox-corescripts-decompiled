local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local RenderChallenge = require(script.Parent.RenderChallenge)

require(script.Parent.InitializeHybridCallback)

local GenericChallengesParent = GenericChallenges.Parent
local Promise = require(GenericChallengesParent.Promise)

require(GenericChallengesParent.LuauPolyfill)

return function(t1: {[any]: any}) -- line: 21
	-- upvalues: Promise (copy), RenderChallenge (copy)
	return Promise.new(function(resolve, reject) -- line: 22
		-- upvalues: RenderChallenge (copy), t1 (copy)
		RenderChallenge({
			title = t1.title,
			rawResponseHeaders = t1.rawResponseHeaders,
			retryRequestCallback = t1.retryRequestCallback,
			challengeErrorCallback = t1.challengeErrorCallback,
			resolve = resolve,
			reject = reject
		})
	end)
end
