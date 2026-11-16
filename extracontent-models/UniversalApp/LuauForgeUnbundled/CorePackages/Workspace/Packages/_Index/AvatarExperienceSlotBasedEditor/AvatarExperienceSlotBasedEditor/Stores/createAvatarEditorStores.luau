require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Stores/createCategoryInventoryStore")
local createSortAndFiltersStore = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Stores/createSortAndFiltersStore")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Stores/createThumbnailLatencyStore")

local function createAvatarEditorStores()
	return {
		categoryInventoryStores = {},
		sortAndFiltersStore = createSortAndFiltersStore(),
		thumbnailLatencyStores = {}
	}
end

return createAvatarEditorStores
