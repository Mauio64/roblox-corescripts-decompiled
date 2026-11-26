local t = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/t")

return {
	CollectionAnalyticsDataInterface = {
		collectionId = t.union(t.number, t.string),
		contentType = t.string,
		itemsPerRow = t.number,
		collectionPosition = t.number,
		startRowNumber = t.optional(t.number),
		totalNumberOfItems = t.number,
		refId = t.optional(t.string)
	},
	ItemAnalyticsDataInterface = {
		id = t.union(t.number, t.string),
		itemPosition = t.optional(t.number)
	}
}
