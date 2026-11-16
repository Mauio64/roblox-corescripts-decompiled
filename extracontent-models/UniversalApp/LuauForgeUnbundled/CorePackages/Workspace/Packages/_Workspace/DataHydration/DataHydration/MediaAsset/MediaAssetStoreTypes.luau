local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/t")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

return {
	mediaAssetResponseItemValidator = t.interface({
		imageId = t.optional(t.union(t.number, t.string)),
		assetTypeId = t.optional(t.number),
		videoId = t.optional(t.union(t.number, t.string)),
		videoHash = t.optional(t.string),
		videoTitle = t.optional(t.string)
	})
}
