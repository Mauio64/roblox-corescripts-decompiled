local GenericType = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/GenericType")
local mountRoCaptchaChallenge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/RoCaptcha/mountRoCaptchaChallenge")
local mountDeniedChallenge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/Denied/mountDeniedChallenge")
local DeniedMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Challenges/Denied/DeniedMetadata")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/ChallengeMetadata")
local FFlagEnableRoCaptchaChallenge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Flags/FFlagEnableRoCaptchaChallenge")
local FFlagEnableDeniedChallenge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Flags/FFlagEnableDeniedChallenge")

local GenericChallengeService = game:GetService("GenericChallengeService")

return {
	canRenderNativeChallenge = function(p2)
		return FFlagEnableRoCaptchaChallenge and p2 == GenericType.toRawValue(GenericType.RoCaptcha) and true
			or FFlagEnableDeniedChallenge and p2 == GenericType.toRawValue(GenericType.Denied)
	end,
	render = function(data)
		local challengeId = data.challengeId
		local genericChallengeService = data.genericChallengeService or GenericChallengeService

		if data.challengeType == GenericType.toRawValue(GenericType.Denied) then
			local challengeMetadata = data.challengeMetadata

			if challengeMetadata and challengeMetadata.reason == DeniedMetadata.DeniedReason.PromptUser then
				mountDeniedChallenge({
					challengeId = challengeId,
					reason = DeniedMetadata.DeniedReason.PromptUser,
					prompt = DeniedMetadata.getPrompt(challengeMetadata),
					onChallengeLoaded = function(p2)
						genericChallengeService:SignalChallengeLoaded(challengeId, p2)
					end,
					onChallengeAbandoned = function()
						genericChallengeService:SignalChallengeAbandoned(challengeId)
					end
				})
			else
				genericChallengeService:SignalChallengeLoaded(challengeId, false)
			end
		elseif data.challengeType == GenericType.toRawValue(GenericType.RoCaptcha) then
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
