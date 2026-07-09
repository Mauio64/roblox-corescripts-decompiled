local Parent = script:FindFirstAncestor("AddFriends").Parent
local ImpressionCacheImpl = require(Parent.SocialCommon).Utils.ImpressionCacheImpl
local EngineFeature = game:GetEngineFeature("RegisterTCEducationBannerImpressionsCountKey")

return ImpressionCacheImpl({
	appStorageKey = "TCEducationBannerImpressionsCount",
	dismissedValue = -1,
	isKeyAvailableInEngine = EngineFeature
})
