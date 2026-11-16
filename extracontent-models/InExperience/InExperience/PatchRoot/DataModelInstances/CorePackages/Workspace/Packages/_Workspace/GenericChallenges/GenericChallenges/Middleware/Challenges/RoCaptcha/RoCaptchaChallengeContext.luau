local GenericChallenges = script:FindFirstAncestor("GenericChallenges")
local ChallengeEventConstants = require(GenericChallenges.Utils.ChallengeEventConstants)

local ChallengeLifecycleEventConstants = ChallengeEventConstants.ChallengeLifecycleEventConstants

return {
	ChallengeInitialized = ChallengeLifecycleEventConstants.ChallengeInitialized,
	ChallengeDisplayed = ChallengeLifecycleEventConstants.ChallengeDisplayed,
	ChallengeInvalidated = ChallengeLifecycleEventConstants.ChallengeInvalidated,
	ChallengeAbandoned = ChallengeLifecycleEventConstants.ChallengeAbandoned,
	ChallengeLaunched = "challengeLaunched"
}
