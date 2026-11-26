local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/React")

local RoCaptchaChallenge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/RoCaptcha/RoCaptchaChallenge")
local mountNativeChallenge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/Common/mountNativeChallenge")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/ChallengeMetadata")

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
