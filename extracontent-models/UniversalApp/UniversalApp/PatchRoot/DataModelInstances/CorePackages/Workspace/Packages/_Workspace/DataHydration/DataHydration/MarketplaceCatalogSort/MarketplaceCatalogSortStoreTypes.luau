local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local t = require(DataHydrationParent.t)

require(DataHydrationParent.Signals)
require(DataHydration.DataHydrationTypes)

return {
	marketplaceCatalogSortResponseItemValidator = t.interface({
		id = t.string,
		type = t.string,
		hydrationPriority = t.number,
		hydrationCount = t.number,
		content = t.table,
		previewColumns = t.optional(t.number),
		title = t.optional(t.string),
		description = t.optional(t.string),
		cardStyle = t.optional(t.table),
		cardFooters = t.optional(t.table),
		tagId = t.optional(t.string)
	})
}
