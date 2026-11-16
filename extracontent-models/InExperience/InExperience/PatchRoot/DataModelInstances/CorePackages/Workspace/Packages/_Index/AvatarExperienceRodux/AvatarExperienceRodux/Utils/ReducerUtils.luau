local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local Constants = AvatarExperienceCommon.Constants

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport

local Constants2 = require(script.Parent.Parent.Constants)
local AssetTypeToAssetCategory = Constants2.AssetTypeToAssetCategory

require(script.Parent.Parent.Types.BodyColors)
require(script.Parent.Parent.Types.OutfitTryOn)

local LOOK_TYPE = Constants.LOOK_TYPE
local ReducerUtils = {}

function ReducerUtils.filterTryOns(items, p)
	local result = {}
	local v = nil

	for k, item in items do
		local v2 = AssetTypeToAssetCategory[p.itemSubType]
		local v3 = not v2 or AssetTypeToAssetCategory[item.itemSubType] ~= v2

		if item.itemSubType == p.itemSubType or not v3 then
			v = item
		else
			result[k] = item
		end
	end

	return result, v
end

function ReducerUtils.convertDefaultBodyColorRanges(items)
	local result = {}

	for _, item in items do
		table.insert(result, { ["rangeId"] = item[1]:ToHex(), range = item })
	end

	return result
end

function ReducerUtils.generateTryOnItemIdKey(p: string, p2, p3)
	if p3 == nil or p3 ~= LOOK_TYPE.Avatar and (not FFlagAXCatalogMakeupSupport or p3 ~= LOOK_TYPE.Makeup) then
		return p
	end

	return tostring(p) .. "-" .. p2
end

function ReducerUtils.generateRecommendedItemsKey(value: string?, value2: string?)
	return (value2 or "") .. "-" .. (value or "")
end

return ReducerUtils
