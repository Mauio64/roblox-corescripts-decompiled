local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
require(parent.AvatarExperienceUIKit)

require(script.Parent.Parent.Types)
require(script.Parent.Parent.Enums.Categories)

local function buildSlotCategoryTabItems(items, p)
	local slotCategoryTabItems = {}

	for k, item in items do
		if not item.hide then
			table.insert(slotCategoryTabItems, {
				id = k,
				text = p[item.nameTranslationKey] or item.nameTranslationKey
			})
		end
	end

	table.sort(slotCategoryTabItems, function(a, b): boolean
		return items[a.id].index < items[b.id].index
	end)

	return slotCategoryTabItems
end

return buildSlotCategoryTabItems
