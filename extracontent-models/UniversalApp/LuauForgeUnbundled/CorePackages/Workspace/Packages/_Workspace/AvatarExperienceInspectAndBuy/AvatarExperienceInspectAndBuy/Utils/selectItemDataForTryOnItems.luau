require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceRodux")
local buildItemDataFromAXRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/buildItemDataFromAXRodux")

local function selectItemDataForTryOnItems(p2, items)
	local itemDataForTryOnItems = {}

	if not (p2 and items) then
		return itemDataForTryOnItems
	end

	for k, item in items do
		local v5 = buildItemDataFromAXRodux(p2, item.itemId, item.itemType)

		if v5 then
			table.insert(itemDataForTryOnItems, {
				itemData = v5,
				isEquipped = item.selectedInTryOnManager == true,
				ordering = item.itemRecency or 0
			})
		end
	end

	table.sort(itemDataForTryOnItems, function(a, b): boolean
		if a.ordering ~= b.ordering then
			return a.ordering < b.ordering
		end

		if a.itemData.id == b.itemData.id then
			return tostring(a.itemData.itemType) < tostring(b.itemData.itemType)
		end

		return tostring(a.itemData.id) < tostring(b.itemData.id)
	end)

	return itemDataForTryOnItems
end

return selectItemDataForTryOnItems
