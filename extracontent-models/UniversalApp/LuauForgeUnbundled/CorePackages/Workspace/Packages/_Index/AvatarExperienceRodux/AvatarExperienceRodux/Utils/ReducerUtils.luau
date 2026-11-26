local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceCommon").Constants

local fFlagAXCatalogMakeupSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceFlags").FFlagAXCatalogMakeupSupport

local assetTypeToAssetCategory = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Constants").AssetTypeToAssetCategory

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Types/BodyColors")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceRodux/AvatarExperienceRodux/Types/OutfitTryOn")

local LOOK_TYPE = constants.LOOK_TYPE

return {
	filterTryOns = function(items, p2)
		local result = {}
		local v5 = nil

		for k, item in items do
			local v6 = assetTypeToAssetCategory[p2.itemSubType]
			local v7 = not v6 or assetTypeToAssetCategory[item.itemSubType] ~= v6

			if item.itemSubType == p2.itemSubType or not v7 then
				v5 = item
			else
				result[k] = item
			end
		end

		return result, v5
	end,
	convertDefaultBodyColorRanges = function(items)
		local result = {}

		for k, item in items do
			table.insert(result, { ["rangeId"] = item[1]:ToHex(), range = item })
		end

		return result
	end,
	generateTryOnItemIdKey = function(p2, p3, p4)
		if
			p4 == nil
			or p4 ~= LOOK_TYPE.Avatar and (not fFlagAXCatalogMakeupSupport or p4 ~= LOOK_TYPE.Makeup)
		then
			return p2
		end

		return tostring(p2) .. "-" .. p3
	end,
	generateRecommendedItemsKey = function(value, value2)
		return (value2 or "") .. "-" .. (value or "")
	end
}
