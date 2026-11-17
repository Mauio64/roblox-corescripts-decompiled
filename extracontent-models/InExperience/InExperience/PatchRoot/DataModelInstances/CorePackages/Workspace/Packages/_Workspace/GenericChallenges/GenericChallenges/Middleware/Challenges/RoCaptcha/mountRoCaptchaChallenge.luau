local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local parent = GenericChallenges.Parent

local React = require(parent.React)

local RoCaptchaChallenge = require(script.Parent.RoCaptchaChallenge)
local mountNativeChallenge = require(script.Parent.Parent.Common.mountNativeChallenge)
require(GenericChallenges.Types.ChallengeMetadata)

return function(data)
	mountNativeChallenge({
		challengeId = data.challengeId,
		shutdownOnTeardown = true,
		mount = data.mount,
		shutdownGame = data.shutdownGame,
		render = function(callback)
			return React.createElement(RoCaptchaChallenge, {
				challengeId = data.challengeId,
				challengeMetadata = data.challengeMetadata,
				experienceService = data.experienceService,
				desiredPlaceId = data.desiredPlaceId,
				logging = data.logging,
				onChallengeLoaded = data.onChallengeLoaded,
				onChallengeFailed = function()
					if data.onChallengeFailed then
						data.onChallengeFailed()
					end

					callback()
				end,
				onChallengeAbandoned = function()
					if data.onChallengeAbandoned then
						data.onChallengeAbandoned()
					end

					callback()
				end,
				onChallengeCompleted = function()
					if data.onChallengeCompleted then
						data.onChallengeCompleted()
					end

					callback()
				end
			})
		end
	})
end
