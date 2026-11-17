local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXEnableInventorySearch = AvatarExperienceFlags.FFlagAXEnableInventorySearch

require(script.Parent.Parent.Stores.createCategoryInventoryStore)
local createInventorySearchStore = require(script.Parent.Parent.Stores.createInventorySearchStore)
local createSortAndFiltersStore = require(script.Parent.Parent.Stores.createSortAndFiltersStore)
require(script.Parent.Parent.Stores.createThumbnailLatencyStore)

local function createAvatarEditorStores()
	local avatarEditorStores = {
		categoryInventoryStores = {},
		sortAndFiltersStore = createSortAndFiltersStore(),
		thumbnailLatencyStores = {},
		inventorySearchStore = 0
	}
	local inventorySearchStore

	if FFlagAXEnableInventorySearch then
		inventorySearchStore = createInventorySearchStore()
	end

	avatarEditorStores.inventorySearchStore = inventorySearchStore
	return avatarEditorStores
end

return createAvatarEditorStores
