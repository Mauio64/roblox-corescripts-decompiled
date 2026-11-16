local FFlagAXStrictCheckForPrefetchMarketplace = require(script.Parent.FFlagAXStrictCheckForPrefetchMarketplace)

return {
	UserIsInTreatment = FFlagAXStrictCheckForPrefetchMarketplace and game:DefineFastFlag(
		"AXPrefetchMarketplaceThumbnailsXPV4",
		false
	),
	UserIsInExperiment = FFlagAXStrictCheckForPrefetchMarketplace and game:DefineFastFlag(
		"AXPrefetchMarketplaceThumbnailsXPExposureV4",
		false
	)
}
