require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/AvatarExperienceUIKit")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Types")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/Categories")

local function buildSlotCategoryTabItems(items, p2)
	local slotCategoryTabItems = {}

	for k, item in items do
		if not item.hide then
			table.insert(slotCategoryTabItems, {
				id = k,
				text = p2[item.nameTranslationKey] or item.nameTranslationKey
			})
		end
	end

	table.sort(slotCategoryTabItems, function(a, b): boolean
		return items[a.id].index < items[b.id].index
	end)

	return slotCategoryTabItems
end

return buildSlotCategoryTabItems
