local RenderChallenge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/RenderChallenge")
local RenderNativeChallenge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/RenderNativeChallenge")
local FFlagEnableRenderNativeChallenge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Middleware/Flags/FFlagEnableRenderNativeChallenge")

local ChallengeType = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Types/ChallengeType")

local base64 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/AuthCommon").Utils.Base64

local HttpService = game:GetService("HttpService")
local GenericChallengeService = game:GetService("GenericChallengeService")

local defineFastFlag = game:DefineFastFlag("FFlagEnableMutexOnGenericChallengeInterceptorMount", false)
local v5 = false

function LUAUFORGE_MODULE_GLOBALS_bZY_challengeRequiredEventHandler(p2, p3, p4)
	if FFlagEnableRenderNativeChallenge and RenderNativeChallenge.canRenderNativeChallenge(p3) then
		RenderNativeChallenge.render({ challengeId = p2, challengeType = p3, challengeMetadata = p4 })
	else
		RenderChallenge({
			challengeType = ChallengeType.Generic,
			challengeParameters = {
				genericChallengeId = p2,
				genericChallengeType = p3,
				genericChallengeMetadata = p4
			},
			callbacks = {
				OnChallengeLoadFailed = function(p5)
					GenericChallengeService:SignalChallengeLoaded(p2, false)
				end,
				OnChallengeCompleted = function(p5)
					if p5.data.metadata ~= nil then
						GenericChallengeService:SignalChallengeCompleted(
							p2,
							p3,
							(base64.Encode(HttpService:JSONEncode(p5.data.metadata)))
						)
					end
				end,
				OnChallengeInvalidated = function(p5)
					GenericChallengeService:SignalChallengeInvalidated(p2)
				end,
				OnChallengeAbandoned = function()
					GenericChallengeService:SignalChallengeAbandoned(p2)
				end
			},
			renderWebViewInModal = true,
			onWebViewOpen = function()
				GenericChallengeService:SignalChallengeLoaded(p2, true)
			end
		})
	end
end

return function()
	if defineFastFlag then
		if not v5 then
			v5 = true
			GenericChallengeService.ChallengeRequiredEvent:Connect(LUAUFORGE_MODULE_GLOBALS_bZY_challengeRequiredEventHandler)
		end
	else
		GenericChallengeService.ChallengeRequiredEvent:Connect(LUAUFORGE_MODULE_GLOBALS_bZY_challengeRequiredEventHandler)
	end
end
