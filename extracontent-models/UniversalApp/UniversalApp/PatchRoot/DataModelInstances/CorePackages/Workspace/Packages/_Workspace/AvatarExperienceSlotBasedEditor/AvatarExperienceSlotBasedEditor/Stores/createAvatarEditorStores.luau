require(script.Parent.Parent.Stores.createCategoryInventoryStore)

local createSortAndFiltersStore = require(script.Parent.Parent.Stores.createSortAndFiltersStore)

local function createAvatarEditorStores() -- line: 19
	-- upvalues: createSortAndFiltersStore (copy)
	return {
		categoryInventoryStores = {},
		sortAndFiltersStore = createSortAndFiltersStore()
	}
end

return createAvatarEditorStores
