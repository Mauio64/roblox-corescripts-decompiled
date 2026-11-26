local module = require("@luauforge/bundled/fCn")
local module2 = require("@luauforge/bundled/dPt")
local inventoryItemType = module.Enums.InventoryItemType
local avatarEditorCategories = module2.Enums.AvatarEditorCategories
local itemTypeEnum = module2.Enums.ItemTypeEnum
local module3 = require("@luauforge/deferred/gTo")

local BACKGROUNDS_CREATE_TILE_ID = require("@luauforge/deferred/hcL").BACKGROUNDS_CREATE_TILE_ID
require("@luauforge/deferred/heh")

local frozen = table.freeze({})

local function createDetailsFetchItem(p2)
	return {
		id = p2,
		itemType = itemTypeEnum.Asset,
		quantityOwned = 0,
		isPurchasable = false
	}
end

local function getPlusExclusiveBackgroundsNeedingDetails(items, p2)
	local plusExclusiveBackgroundsNeedingDetails = {}

	for k, item in items do
		local itemId = item.itemId

		if not (itemId and itemId ~= BACKGROUNDS_CREATE_TILE_ID and item.inventoryItemType == inventoryItemType.Asset and item.isPlusExclusive) then
			continue
		end

		local v5 = p2 and p2[itemId]

		if not (v5 and v5.name) then
			table.insert(plusExclusiveBackgroundsNeedingDetails, {
				id = itemId,
				itemType = itemTypeEnum.Asset,
				quantityOwned = 0,
				isPurchasable = false
			})
		end
	end

	return plusExclusiveBackgroundsNeedingDetails
end

local function getPlusExclusiveBackgroundsDetailsFetchKey(p2, p3)
	local plusExclusiveBackgroundsNeedingDetails = getPlusExclusiveBackgroundsNeedingDetails(p2, p3)

	if #plusExclusiveBackgroundsNeedingDetails == 0 then
		return ""
	end

	local ids = table.create(#plusExclusiveBackgroundsNeedingDetails)

	for k, plusExclusiveBackgroundsNeedingDetail in plusExclusiveBackgroundsNeedingDetails do
		ids[k] = plusExclusiveBackgroundsNeedingDetail.id
	end

	table.sort(ids)
	return table.concat(ids, ",")
end

local function getPlusExclusiveBackgroundsFromDetailsFetchKey(value)
	if value == "" then
		return frozen
	end

	local result = {}

	for k, v5 in string.split(value, ",") do
		table.insert(result, {
			id = v5,
			itemType = itemTypeEnum.Asset,
			quantityOwned = 0,
			isPurchasable = false
		})
	end

	return result
end

return {
	getItemsNeedingDetails = getPlusExclusiveBackgroundsNeedingDetails,
	getDetailsFetchKey = getPlusExclusiveBackgroundsDetailsFetchKey,
	getItemsFromDetailsFetchKey = getPlusExclusiveBackgroundsFromDetailsFetchKey,
	getDetailsFetchKeyForCategory = function(p2, p3, p4)
		if p2 == avatarEditorCategories.Backgrounds then
			return getPlusExclusiveBackgroundsDetailsFetchKey(p3, p4)
		end

		return ""
	end,
	dispatchDetailsFetchIfNeeded = function(callback, p2, list)
		if #list > 0 then
			callback(module3(p2, nil, list))
		end
	end
}
