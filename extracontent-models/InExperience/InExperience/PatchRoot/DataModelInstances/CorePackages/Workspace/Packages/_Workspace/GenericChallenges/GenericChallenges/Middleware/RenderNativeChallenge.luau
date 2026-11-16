local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local GenericType = require(GenericChallenges.Types.GenericType)
local mountRoCaptchaChallenge = require(script.Parent.Challenges.RoCaptcha.mountRoCaptchaChallenge)
local FFlagEnableRoCaptchaChallenge = require(script.Parent.Flags.FFlagEnableRoCaptchaChallenge)

local GenericChallengeService = game:GetService("GenericChallengeService")
local RenderNativeChallenge = {}

function RenderNativeChallenge.canRenderNativeChallenge(p: string)
	return FFlagEnableRoCaptchaChallenge and p == GenericType.toRawValue(GenericType.RoCaptcha)
end

function RenderNativeChallenge.render(data)
	local challengeId = data.challengeId
	local genericChallengeService = data.genericChallengeService or GenericChallengeService

	if data.challengeType == GenericType.toRawValue(GenericType.RoCaptcha) then
		mountRoCaptchaChallenge({
			challengeId = challengeId,
			challengeMetadata = data.challengeMetadata,
			onChallengeLoaded = function(flag: boolean)
				genericChallengeService:SignalChallengeLoaded(challengeId, flag)
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

return RenderNativeChallenge
