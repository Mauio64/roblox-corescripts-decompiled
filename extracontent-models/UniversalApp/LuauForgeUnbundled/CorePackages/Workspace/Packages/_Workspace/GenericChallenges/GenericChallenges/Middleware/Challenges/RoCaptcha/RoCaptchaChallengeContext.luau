local challengeLifecycleEventConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericChallenges/GenericChallenges/Utils/ChallengeEventConstants").ChallengeLifecycleEventConstants

return {
	ChallengeInitialized = challengeLifecycleEventConstants.ChallengeInitialized,
	ChallengeDisplayed = challengeLifecycleEventConstants.ChallengeDisplayed,
	ChallengeInvalidated = challengeLifecycleEventConstants.ChallengeInvalidated,
	ChallengeAbandoned = challengeLifecycleEventConstants.ChallengeAbandoned,
	ChallengeLaunched = "challengeLaunched"
}
