local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local GenericType = require(GenericChallenges.Types.GenericType)
local mountRoCaptchaChallenge = require(script.Parent.Challenges.RoCaptcha.mountRoCaptchaChallenge)
local mountDeniedChallenge = require(script.Parent.Challenges.Denied.mountDeniedChallenge)
local DeniedMetadata = require(script.Parent.Challenges.Denied.DeniedMetadata)
require(GenericChallenges.Types.ChallengeMetadata)
local FFlagEnableRoCaptchaChallenge = require(script.Parent.Flags.FFlagEnableRoCaptchaChallenge)
local FFlagEnableDeniedChallenge = require(script.Parent.Flags.FFlagEnableDeniedChallenge)

local GenericChallengeService = game:GetService("GenericChallengeService")
local RenderNativeChallenge = {}

function RenderNativeChallenge.canRenderNativeChallenge(p: string)
	return FFlagEnableRoCaptchaChallenge and p == GenericType.toRawValue(GenericType.RoCaptcha) and true
		or FFlagEnableDeniedChallenge and p == GenericType.toRawValue(GenericType.Denied)
end

function RenderNativeChallenge.render(data)
	local challengeId = data.challengeId
	local genericChallengeService = data.genericChallengeService or GenericChallengeService

	if data.challengeType == GenericType.toRawValue(GenericType.Denied) then
		local challengeMetadata = data.challengeMetadata

		if challengeMetadata and challengeMetadata.reason == DeniedMetadata.DeniedReason.PromptUser then
			mountDeniedChallenge({
				challengeId = challengeId,
				reason = DeniedMetadata.DeniedReason.PromptUser,
				prompt = DeniedMetadata.getPrompt(challengeMetadata),
				onChallengeLoaded = function(flag: boolean)
					genericChallengeService:SignalChallengeLoaded(challengeId, flag)
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
