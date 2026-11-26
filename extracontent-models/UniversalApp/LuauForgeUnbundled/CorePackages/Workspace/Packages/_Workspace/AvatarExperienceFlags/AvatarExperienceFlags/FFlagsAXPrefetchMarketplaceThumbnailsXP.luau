local FFlagAXStrictCheckForPrefetchMarketplace = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXStrictCheckForPrefetchMarketplace")

return {
	UserIsInTreatment = FFlagAXStrictCheckForPrefetchMarketplace and game:DefineFastFlag("AXPrefetchMarketplaceThumbnailsXPV4", false),
	UserIsInExperiment = FFlagAXStrictCheckForPrefetchMarketplace and game:DefineFastFlag(
		"AXPrefetchMarketplaceThumbnailsXPExposureV4",
		false
	)
}
