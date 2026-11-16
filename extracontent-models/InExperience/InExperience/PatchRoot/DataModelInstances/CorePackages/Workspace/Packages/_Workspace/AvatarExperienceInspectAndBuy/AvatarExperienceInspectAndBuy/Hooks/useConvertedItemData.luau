local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
require(AvatarExperienceInspectAndBuy.Types)
local AvatarExperienceModel = require(AvatarExperienceInspectAndBuy.Parent.AvatarExperienceModel)
local React = require(parent.React)
local useMemo = React.useMemo
local useCallback = React.useCallback
local RoactUtils = require(parent.RoactUtils)
local convertAssetInfoToItemData = require(AvatarExperienceInspectAndBuy.Utils.convertAssetInfoToItemData)
local convertBundleInfoToItemData = require(AvatarExperienceInspectAndBuy.Utils.convertBundleInfoToItemData)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local tutils = require(parent.tutils)
local Http = require(parent.Http)
local PerformFetch = Http.PerformFetch
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXEnableBatchItemDetailsFetchV2 = AvatarExperienceFlags.FFlagAXEnableBatchItemDetailsFetchV2
local Constants = require(AvatarExperienceInspectAndBuy.Constants)
local BatchItemDetailsPerformFetchKey = Constants.BatchItemDetailsPerformFetchKey

local function getResellableInsances(p)
	return p.collectibleResellableInstances
end

local function useConvertedItemData(p)
	local id

	if p then
		id = p.id
	else
		id = nil
	end

	local itemType

	if p then
		itemType = p.itemType
	else
		itemType = nil
	end

	local v = useCallback(function(p2)
		if itemType == ItemTypeEnum.Asset then
			return p2.assets[id]
		end

		if itemType == ItemTypeEnum.Bundle then
			return p2.bundles[id]
		end

		return nil
	end, { id, itemType })

	local v2 = useCallback(function(p2)
		if FFlagAXEnableBatchItemDetailsFetchV2 then
			return PerformFetch.GetStatus(p2, BatchItemDetailsPerformFetchKey)
		end

		if not (id and itemType) then
			return nil
		end

		local storeId = p2.storeId
		local v2

		if itemType == ItemTypeEnum.Asset then
			v2 = tostring(Enum.AvatarItemType.Asset)
		else
			v2 = tostring(Enum.AvatarItemType.Bundle)
		end

		local v3 = string.format("inspectAndBuy.%d.getItemDetails.%s.%s", storeId, id, v2)

		return PerformFetch.GetStatus(p2, v3)
	end, { id, itemType })

	local v3 = useSelector(v, tutils.deepEqual)
	local v4 = useSelector(getResellableInsances, tutils.deepEqual)
	local v5 = useSelector(v2, tutils.deepEqual)

	return useMemo(function()
		local v6

		if v3 and v3.collectibleItemId ~= nil and v4 ~= nil then
			v6 = v4[v3.collectibleItemId]
		end

		if not v3 then
			return nil
		end

		if itemType == ItemTypeEnum.Asset then
			return (convertAssetInfoToItemData(v3, v6))
		end

		if itemType == ItemTypeEnum.Bundle then
			return (convertBundleInfoToItemData(v3, v6))
		end

		return nil
	end, { v3, v4, itemType }), v5
end

return useConvertedItemData
