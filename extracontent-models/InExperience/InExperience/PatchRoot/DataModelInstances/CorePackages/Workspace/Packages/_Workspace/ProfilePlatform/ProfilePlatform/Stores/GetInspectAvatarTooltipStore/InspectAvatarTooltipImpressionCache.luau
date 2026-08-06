local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local ImpressionCacheImpl = require(Parent.SocialCommon).Utils.ImpressionCacheImpl
local EngineFeature = game:GetEngineFeature("ProfileInspectAndBuyImpressionCountStorageKey")

return ImpressionCacheImpl({
	appStorageKey = "ProfileInspectAndBuyImpressionCount",
	dismissedValue = -1,
	isKeyAvailableInEngine = EngineFeature
})
