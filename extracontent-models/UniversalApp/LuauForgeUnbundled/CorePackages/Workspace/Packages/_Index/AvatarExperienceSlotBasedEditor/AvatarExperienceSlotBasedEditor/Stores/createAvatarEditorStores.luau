local fFlagAXEnableInventorySearch = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceFlags").FFlagAXEnableInventorySearch

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Stores/createCategoryInventoryStore")
local createInventorySearchStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Stores/createInventorySearchStore")
local createSortAndFiltersStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Stores/createSortAndFiltersStore")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Stores/createThumbnailLatencyStore")

local function createAvatarEditorStores()
	local avatarEditorStores = {
		categoryInventoryStores = {},
		sortAndFiltersStore = createSortAndFiltersStore(),
		thumbnailLatencyStores = {},
		inventorySearchStore = 0
	}
	local v5 = if fFlagAXEnableInventorySearch then createInventorySearchStore() else nil
	avatarEditorStores.inventorySearchStore = v5
	return avatarEditorStores
end

return createAvatarEditorStores
