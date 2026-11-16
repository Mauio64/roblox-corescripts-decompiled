local GenericType = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/GenericType")
local mountRoCaptchaChallenge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/RoCaptcha/mountRoCaptchaChallenge")
local FFlagEnableRoCaptchaChallenge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Flags/FFlagEnableRoCaptchaChallenge")

local GenericChallengeService = game:GetService("GenericChallengeService")

return {
	canRenderNativeChallenge = function(p2)
		return FFlagEnableRoCaptchaChallenge and p2 == GenericType.toRawValue(GenericType.RoCaptcha)
	end,
	render = function(data)
		local challengeId = data.challengeId
		local genericChallengeService = data.genericChallengeService or GenericChallengeService

		if data.challengeType == GenericType.toRawValue(GenericType.RoCaptcha) then
			mountRoCaptchaChallenge({
				challengeId = challengeId,
				challengeMetadata = data.challengeMetadata,
				onChallengeLoaded = function(p2)
					genericChallengeService:SignalChallengeLoaded(challengeId, p2)
				end,
				onChallengeFailed = function()
					genericChallengeService:SignalChallengeAbandoned(challengeId)
				end,
				onChallengeAbandoned = function()
					genericChallengeService:SignalChallengeAbandoned(challengeId)
				end
			})
		end
	end
}
