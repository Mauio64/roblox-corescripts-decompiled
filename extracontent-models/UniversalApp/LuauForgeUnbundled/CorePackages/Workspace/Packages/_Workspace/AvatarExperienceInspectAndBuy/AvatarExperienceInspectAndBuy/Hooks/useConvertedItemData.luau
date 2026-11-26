require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local AvatarExperienceModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceModel")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/React")
local useMemo = React.useMemo
local useCallback = React.useCallback
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/RoactUtils")
local convertAssetInfoToItemData = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/convertAssetInfoToItemData")
local convertBundleInfoToItemData = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/convertBundleInfoToItemData")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/tutils")
local performFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Http").PerformFetch
local itemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local fFlagAXEnableBatchItemDetailsFetchV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceFlags").FFlagAXEnableBatchItemDetailsFetchV2
local batchItemDetailsPerformFetchKey = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Constants").BatchItemDetailsPerformFetchKey

local function getResellableInsances(p2)
	return p2.collectibleResellableInstances
end

local function useConvertedItemData(p2)
	local id = if p2 then p2.id else nil
	local itemType = if p2 then p2.itemType else nil

	local v5 = useCallback(function(p3)
		if itemType == itemTypeEnum.Asset then
			return p3.assets[id]
		end

		if itemType == itemTypeEnum.Bundle then
			return p3.bundles[id]
		end

		return nil
	end, { id, itemType })

	local v6 = useCallback(function(p3)
		if fFlagAXEnableBatchItemDetailsFetchV2 then
			return performFetch.GetStatus(p3, batchItemDetailsPerformFetchKey)
		end

		if not (id and itemType) then
			return nil
		end

		local format = string.format

		local storeId = p3.storeId
		local v9

		if itemType == itemTypeEnum.Asset then
			v9 = tostring(Enum.AvatarItemType.Asset)
		else
			v9 = tostring(Enum.AvatarItemType.Bundle)
		end

		local v10 = format("inspectAndBuy.%d.getItemDetails.%s.%s", storeId, id, v9)

		return performFetch.GetStatus(p3, v10)
	end, { id, itemType })

	local v7 = useSelector(v5, tutils.deepEqual)
	local v8 = useSelector(getResellableInsances, tutils.deepEqual)
	local v9 = useSelector(v6, tutils.deepEqual)

	return useMemo(function()
		local v10 = if v7 and v7.collectibleItemId ~= nil and v8 ~= nil then v8[v7.collectibleItemId] else nil

		if not v7 then
			return nil
		end

		if itemType == itemTypeEnum.Asset then
			return convertAssetInfoToItemData(v7, v10)
		end

		if itemType == itemTypeEnum.Bundle then
			return convertBundleInfoToItemData(v7, v10)
		end

		return nil
	end, { v7, v8, itemType }), v9
end

return useConvertedItemData
