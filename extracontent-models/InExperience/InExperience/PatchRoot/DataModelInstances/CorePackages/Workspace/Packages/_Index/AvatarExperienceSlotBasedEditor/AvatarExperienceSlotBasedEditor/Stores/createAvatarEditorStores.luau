require(script.Parent.Parent.Stores.createCategoryInventoryStore)
local createSortAndFiltersStore = require(script.Parent.Parent.Stores.createSortAndFiltersStore)
require(script.Parent.Parent.Stores.createThumbnailLatencyStore)

local function createAvatarEditorStores()
	return {
		categoryInventoryStores = {},
		sortAndFiltersStore = createSortAndFiltersStore(),
		thumbnailLatencyStores = {}
	}
end

return createAvatarEditorStores
