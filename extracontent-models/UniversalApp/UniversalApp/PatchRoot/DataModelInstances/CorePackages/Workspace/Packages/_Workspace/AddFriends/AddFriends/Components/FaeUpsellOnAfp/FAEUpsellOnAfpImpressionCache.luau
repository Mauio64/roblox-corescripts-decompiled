local Parent = script:FindFirstAncestor("AddFriends").Parent
local ImpressionCacheImpl = require(Parent.SocialCommon).Utils.ImpressionCacheImpl
local EngineFeature = game:GetEngineFeature("RegisterFAEUpsellOnAfpImpressionsCountKey")

return ImpressionCacheImpl({
	appStorageKey = "FAEUpsellOnAfpImpressionsCount",
	dismissedValue = -1,
	isKeyAvailableInEngine = EngineFeature
})
