local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local inventoryItemType = require("@luauforge/bundled/fuM").Enums.InventoryItemType

require("@luauforge/deferred/gRV")

local getTemporaryPlusBackgroundIds = AvatarExperienceCommon.Backgrounds.getTemporaryPlusBackgroundIds

local function appendUnownedPlusExclusiveBackgrounds(items)
	local temporaryPlusBackgroundIds, v5 = getTemporaryPlusBackgroundIds()

	if v5 then
		return items
	end

	local itemIdSet = {}

	for k, item in items do
		if item.itemId then
			itemIdSet[tostring(item.itemId)] = true
		end
	end

	local v6 = {}

	for k in temporaryPlusBackgroundIds do
		if not itemIdSet[k] then
			table.insert(v6, k)
		end
	end

	if #v6 == 0 then
		return items
	end

	table.sort(v6)

	local clone = table.clone(items)

	for k, v7 in v6 do
		table.insert(clone, {
			itemId = v7,
			inventoryItemType = inventoryItemType.Asset,
			isPlusExclusive = true
		})
	end

	return clone
end

return appendUnownedPlusExclusiveBackgrounds
