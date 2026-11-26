local InventorySearchConstants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/InventorySearchConstants")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/InventorySearchItemType")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Types")

local searchableSubtypesByItemType = InventorySearchConstants.SearchableSubtypesByItemType

local function toSearchableItemCategories(items)
	local searchableItemCategories = {}

	for k, item in items do
		local itemType = string.lower(item.itemType)
		local searchableSubtype = searchableSubtypesByItemType[itemType]

		if searchableSubtype and searchableSubtype[item.itemSubType] then
			table.insert(searchableItemCategories, {
				itemType = itemType,
				itemSubType = item.itemSubType
			})
		end
	end

	return searchableItemCategories
end

return toSearchableItemCategories
