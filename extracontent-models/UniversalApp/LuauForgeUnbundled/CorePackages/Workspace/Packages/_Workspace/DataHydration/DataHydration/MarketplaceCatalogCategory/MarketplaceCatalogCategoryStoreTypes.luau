local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/t")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

return {
	marketplaceCatalogCategoryResponseItemValidator = t.interface({
		id = t.string,
		title = t.string,
		name = t.string,
		taxonomyId = t.optional(t.string),
		buttonsEnabled = t.optional(t.table),
		subcategories = t.optional(t.table),
		defaultSubcategoryId = t.optional(t.string),
		assetTypes = t.optional(t.table),
		bundleTypes = t.optional(t.table),
		canAnimateCameraBasedMood = t.optional(t.boolean),
		cameraFocus = t.optional(t.string),
		cameraZoomRadius = t.optional(t.number),
		tileType = t.optional(t.string),
		timeToRefresh = t.optional(t.number),
		categoryId = t.optional(t.number),
		subcategoryId = t.optional(t.number),
		looksWidgetContextForOrganicContent = t.optional(t.string)
	})
}
