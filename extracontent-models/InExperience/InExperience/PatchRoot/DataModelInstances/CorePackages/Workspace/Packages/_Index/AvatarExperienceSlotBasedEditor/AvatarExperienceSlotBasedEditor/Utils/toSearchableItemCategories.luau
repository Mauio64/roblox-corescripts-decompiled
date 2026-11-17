local AvatarExperienceSlotBasedEditor = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor")

local InventorySearchConstants = require(AvatarExperienceSlotBasedEditor.InventorySearchConstants)
require(AvatarExperienceSlotBasedEditor.Enums.InventorySearchItemType)
require(AvatarExperienceSlotBasedEditor.Types)

local SearchableSubtypesByItemType = InventorySearchConstants.SearchableSubtypesByItemType

local function toSearchableItemCategories(items)
	local searchableItemCategories = {}

	for _, item in items do
		local itemType = string.lower(item.itemType)
		local searchableSubtype = SearchableSubtypesByItemType[itemType]

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
