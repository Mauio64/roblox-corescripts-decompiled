local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
require(AvatarExperienceInspectAndBuy.Types)
require(parent.AvatarExperienceRodux)
local buildItemDataFromAXRodux = require(AvatarExperienceInspectAndBuy.Utils.buildItemDataFromAXRodux)

local function selectItemDataForTryOnItems(p, items)
	local itemDataForTryOnItems = {}

	if not (p and items) then
		return itemDataForTryOnItems
	end

	for _, item in items do
		local itemDataFromAXRodux = buildItemDataFromAXRodux(p, item.itemId, item.itemType)

		if itemDataFromAXRodux then
			table.insert(itemDataForTryOnItems, {
				itemData = itemDataFromAXRodux,
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
