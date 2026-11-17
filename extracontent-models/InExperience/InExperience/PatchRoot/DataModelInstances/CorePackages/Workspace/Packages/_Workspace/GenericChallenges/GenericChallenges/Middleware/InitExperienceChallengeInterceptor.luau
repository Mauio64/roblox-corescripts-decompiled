local RenderChallenge = require(script.Parent.RenderChallenge)
local RenderNativeChallenge = require(script.Parent.RenderNativeChallenge)
local FFlagEnableRenderNativeChallenge = require(script.Parent.Flags.FFlagEnableRenderNativeChallenge)
local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local ChallengeType = require(GenericChallenges.Types.ChallengeType)
local decodeChallengeMetadata = require(GenericChallenges.Utils.decodeChallengeMetadata)
local parent = GenericChallenges.Parent
local AuthCommon = require(parent.AuthCommon)
local Base64 = AuthCommon.Utils.Base64

local HttpService = game:GetService("HttpService")
local GenericChallengeService = game:GetService("GenericChallengeService")

local defineFastFlag = game:DefineFastFlag("FFlagEnableMutexOnGenericChallengeInterceptorMount", false)
local v = false

function challengeRequiredEventHandler(p: string, p2: string, genericChallengeMetadata: string)
	if FFlagEnableRenderNativeChallenge and RenderNativeChallenge.canRenderNativeChallenge(p2) then
		RenderNativeChallenge.render({
			challengeId = p,
			challengeType = p2,
			challengeMetadata = decodeChallengeMetadata(genericChallengeMetadata)
		})
	else
		RenderChallenge({
			challengeType = ChallengeType.Generic,
			challengeParameters = {
				genericChallengeId = p,
				genericChallengeType = p2,
				genericChallengeMetadata = genericChallengeMetadata
			},
			callbacks = {
				OnChallengeLoadFailed = function(_)
					GenericChallengeService:SignalChallengeLoaded(p, false)
				end,
				OnChallengeCompleted = function(p3)
					if p3.data.metadata ~= nil then
						GenericChallengeService:SignalChallengeCompleted(
							p,
							p2,
							(Base64.Encode(HttpService:JSONEncode(p3.data.metadata)))
						)
					end
				end,
				OnChallengeInvalidated = function(_)
					GenericChallengeService:SignalChallengeInvalidated(p)
				end,
				OnChallengeAbandoned = function()
					GenericChallengeService:SignalChallengeAbandoned(p)
				end
			},
			renderWebViewInModal = true,
			onWebViewOpen = function()
				GenericChallengeService:SignalChallengeLoaded(p, true)
			end
		})
	end
end

return function()
	if defineFastFlag then
		if not v then
			v = true
			GenericChallengeService.ChallengeRequiredEvent:Connect(challengeRequiredEventHandler)
		end
	else
		GenericChallengeService.ChallengeRequiredEvent:Connect(challengeRequiredEventHandler)
	end
end
