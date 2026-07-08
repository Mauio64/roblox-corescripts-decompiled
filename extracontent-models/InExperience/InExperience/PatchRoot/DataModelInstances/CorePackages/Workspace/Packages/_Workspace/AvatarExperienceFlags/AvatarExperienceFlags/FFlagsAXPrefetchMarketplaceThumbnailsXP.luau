local FFlagAXStrictCheckForPrefetchMarketplace = require(script.Parent.FFlagAXStrictCheckForPrefetchMarketplace)
local v2 = FFlagAXStrictCheckForPrefetchMarketplace and game:DefineFastFlag("AXPrefetchMarketplaceThumbnailsXPV4", false)
local v3 = FFlagAXStrictCheckForPrefetchMarketplace and game:DefineFastFlag("AXPrefetchMarketplaceThumbnailsXPExposureV4", false)

return {
	UserIsInTreatment = v2,
	UserIsInExperiment = v3
}
