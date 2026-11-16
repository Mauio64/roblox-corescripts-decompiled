local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local SocialCommon = require(parent.SocialCommon)
return SocialCommon.Utils.ImpressionCacheImpl({
	appStorageKey = "ProfileInspectAndBuyImpressionCount",
	dismissedValue = -1,
	isKeyAvailableInEngine = game:GetEngineFeature("ProfileInspectAndBuyImpressionCountStorageKey")
})
