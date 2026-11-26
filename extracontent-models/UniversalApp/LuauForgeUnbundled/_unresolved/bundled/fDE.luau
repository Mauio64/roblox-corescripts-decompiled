local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module2 = require("@luauforge/bundled/dPN")
require("@luauforge/bundled/dKT")
require("@luauforge/bundled/dPs")

local ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE = AvatarExperienceCommon.Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE

local v5 = memoize(function(items, items2)
	local result = {}
	local orders = {}

	local set = {}

	local flag = true

	if not (items and items2) then
		return {}, true
	end

	for k, item in items2 do
		if item.itemType == module2.ItemType.Asset then
			local itemSubType = item.itemSubType

			if
				not module2.LCIgnoredForSorting[itemSubType]
				and item.isLayered
				and not ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[itemSubType]
			then
				set[itemSubType] = true
				orders[item.itemId] = item.order or module2.LayeredClothingOrder[itemSubType]

				if item.order and item.order ~= module2.LayeredClothingOrder[itemSubType] then
					flag = false
				end

				table.insert(result, { id = item.itemId, typeId = itemSubType })
			end
		elseif item.bundleInfo then
			for k2, v6 in item.bundleInfo do
				local assetType = v6.assetType
				local v7 = module2.LayeredAssetTypes[assetType] ~= nil

				if
					module2.LCIgnoredForSorting[assetType]
					or not v7
					or ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[assetType]
				then
					continue
				end

				set[assetType] = true
				orders[k2] = v6.order or module2.LayeredClothingOrder[assetType]

				if v6.order and v6.order ~= module2.LayeredClothingOrder[assetType] then
					flag = false
				end

				table.insert(result, { id = k2, typeId = assetType })
			end
		end
	end

	for k, item in items do
		for k2, v6 in item do
			if
				set[k]
				or module2.LCIgnoredForSorting[k]
				or not v6.isLayered
				or ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[k]
			then
				continue
			end

			orders[k2] = v6.order or module2.LayeredClothingOrder[k]

			if v6.order and v6.order ~= module2.LayeredClothingOrder[k] then
				flag = false
			end

			table.insert(result, { id = k2, typeId = k })
		end
	end

	if flag then
		return {}, flag
	end

	table.sort(result, function(a, b): boolean
		return orders[a.id] > orders[b.id]
	end)

	return result, flag
end)

return function(p2)
	return v5(
		p2.AvatarExperience.AvatarEditor.Character.EquippedAssets,
		p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	)
end
