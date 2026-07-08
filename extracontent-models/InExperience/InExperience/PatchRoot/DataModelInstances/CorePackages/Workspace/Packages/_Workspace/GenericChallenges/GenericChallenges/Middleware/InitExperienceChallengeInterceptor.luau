local RenderChallenge = require(script.Parent.RenderChallenge)
local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local ChallengeType = require(GenericChallenges.Types.ChallengeType)
local GenericChallengesParent = GenericChallenges.Parent
local Base64 = require(GenericChallengesParent.AuthCommon).Utils.Base64
local HttpService = game:GetService("HttpService")
local GenericChallengeService = game:GetService("GenericChallengeService")
local v8 = game:DefineFastFlag("FFlagEnableMutexOnGenericChallengeInterceptorMount", false)
local u9 = false

function challengeRequiredEventHandler(s1: string, s2: string, s3: string) -- line: 15
	-- upvalues: RenderChallenge (copy), ChallengeType (copy), GenericChallengeService (copy), Base64 (copy), HttpService (copy)
	RenderChallenge({
		renderWebViewInModal = true,
		challengeType = ChallengeType.Generic,
		challengeParameters = {
			genericChallengeId = s1,
			genericChallengeType = s2,
			genericChallengeMetadata = s3
		},
		callbacks = {
			OnChallengeLoadFailed = function(_) -- line: 24
				-- upvalues: GenericChallengeService (copy), s1 (copy)
				GenericChallengeService:SignalChallengeLoaded(s1, false)
			end,
			OnChallengeCompleted = function(p2) -- line: 29
				-- upvalues: Base64 (copy), HttpService (copy), GenericChallengeService (copy), s1 (copy), s2 (copy)
				if p2.data.metadata ~= nil then
					local v15 = Base64.Encode(HttpService:JSONEncode(p2.data.metadata))

					GenericChallengeService:SignalChallengeCompleted(s1, s2, v15)
				end
			end,
			OnChallengeInvalidated = function(_) -- line: 35
				-- upvalues: GenericChallengeService (copy), s1 (copy)
				GenericChallengeService:SignalChallengeInvalidated(s1)
			end,
			OnChallengeAbandoned = function() -- line: 38
				-- upvalues: GenericChallengeService (copy), s1 (copy)
				GenericChallengeService:SignalChallengeAbandoned(s1)
			end
		},
		onWebViewOpen = function() -- line: 43
			-- upvalues: GenericChallengeService (copy), s1 (copy)
			GenericChallengeService:SignalChallengeLoaded(s1, true)
		end
	})
end

return function() -- line: 49
	-- upvalues: v8 (copy), u9 (ref), GenericChallengeService (copy)
	if v8 then
		if not u9 then
			u9 = true
			GenericChallengeService.ChallengeRequiredEvent:Connect(challengeRequiredEventHandler)

			return
		end
	else
		GenericChallengeService.ChallengeRequiredEvent:Connect(challengeRequiredEventHandler)
	end
end
