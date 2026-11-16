local parent = script:FindFirstAncestor("ContactImporter").Parent

local SocialCommon = require(parent.SocialCommon)
return (SocialCommon.Utils.ImpressionCacheImpl({
	appStorageKey = "ContactsSyncWarningImpressionsCount",
	isKeyAvailableInEngine = game:GetEngineFeature("RegisterContactsSyncWarningImpressionsCountKey"),
	dismissedValue = -1
}))
