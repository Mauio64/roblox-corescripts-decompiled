local Parent = script:FindFirstAncestor("ContactImporter").Parent
local ImpressionCacheImpl = require(Parent.SocialCommon).Utils.ImpressionCacheImpl
local EngineFeature = game:GetEngineFeature("RegisterContactsSyncWarningImpressionsCountKey")

return (ImpressionCacheImpl({
	appStorageKey = "ContactsSyncWarningImpressionsCount",
	dismissedValue = -1,
	isKeyAvailableInEngine = EngineFeature
}))
