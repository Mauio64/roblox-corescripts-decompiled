return (require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SocialCommon").Utils.ImpressionCacheImpl({
	appStorageKey = "ContactsSyncWarningImpressionsCount",
	isKeyAvailableInEngine = game:GetEngineFeature("RegisterContactsSyncWarningImpressionsCountKey"),
	dismissedValue = -1
}))
