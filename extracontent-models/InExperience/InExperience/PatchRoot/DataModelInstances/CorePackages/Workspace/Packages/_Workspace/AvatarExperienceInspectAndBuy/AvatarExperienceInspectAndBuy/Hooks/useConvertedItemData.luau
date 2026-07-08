local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent

require(AvatarExperienceInspectAndBuy.Types)

local AXCommon = require(AvatarExperienceInspectAndBuy.Parent.AXCommon)
local React = require(AvatarExperienceInspectAndBuyParent.React)
local useMemo = React.useMemo
local useCallback = React.useCallback
local RoactUtils = require(AvatarExperienceInspectAndBuyParent.RoactUtils)
local convertAssetInfoToItemData = require(AvatarExperienceInspectAndBuy.Utils.convertAssetInfoToItemData)
local convertBundleInfoToItemData = require(AvatarExperienceInspectAndBuy.Utils.convertBundleInfoToItemData)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local tutils = require(AvatarExperienceInspectAndBuyParent.tutils)
local PerformFetch = require(AvatarExperienceInspectAndBuyParent.Http).PerformFetch
local ItemTypeEnum = AXCommon.Enums.ItemTypeEnum
local FFlagAXEnableBatchItemDetailsFetchV2 = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceFlags).FFlagAXEnableBatchItemDetailsFetchV2
local BatchItemDetailsPerformFetchKey = require(AvatarExperienceInspectAndBuy.Constants).BatchItemDetailsPerformFetchKey

local function getResellableInsances(p1) -- line: 28
	return p1.collectibleResellableInstances
end
local function useConvertedItemData(p2) -- line: 36
	-- upvalues: useCallback (copy), ItemTypeEnum (copy), FFlagAXEnableBatchItemDetailsFetchV2 (copy), PerformFetch (copy), BatchItemDetailsPerformFetchKey (copy), useSelector (copy), tutils (copy), getResellableInsances (copy), useMemo (copy), convertAssetInfoToItemData (copy), convertBundleInfoToItemData (copy)
	local v20 = if not p2 then nil else p2.id
	local v21 = if not p2 then nil else p2.itemType
	local v22 = useCallback(function(p3) -- line: 40
		-- upvalues: v21 (copy), ItemTypeEnum (copy), v20 (copy)
		if v21 == ItemTypeEnum.Asset then
			return p3.assets[v20]
		end

		if v21 == ItemTypeEnum.Bundle then
			return p3.bundles[v20]
		end

		return nil
	end, {
		v20,
		v21
	})
	local v23 = useCallback(function(p4) -- line: 49
		-- upvalues: FFlagAXEnableBatchItemDetailsFetchV2 (copy), PerformFetch (copy), BatchItemDetailsPerformFetchKey (copy), v20 (copy), v21 (copy), ItemTypeEnum (copy)
		if FFlagAXEnableBatchItemDetailsFetchV2 then
			return PerformFetch.GetStatus(p4, BatchItemDetailsPerformFetchKey)
		end

		if v20 and v21 then
			local v29 = string.format("inspectAndBuy.%d.getItemDetails.%s.%s", p4.storeId, v20, if v21 ~= ItemTypeEnum.Asset then tostring(Enum.AvatarItemType.Bundle) else tostring(Enum.AvatarItemType.Asset))

			return PerformFetch.GetStatus(p4, v29)
		end

		return nil
	end, {
		v20,
		v21
	})
	local v24 = useSelector(v22, tutils.deepEqual)
	local v25 = useSelector(getResellableInsances, tutils.deepEqual)
	local v26 = useSelector(v23, tutils.deepEqual)

	return useMemo(function() -- line: 74
		-- upvalues: v24 (copy), v25 (copy), v21 (copy), ItemTypeEnum (copy), convertAssetInfoToItemData (copy), convertBundleInfoToItemData (copy)
		local v30 = nil

		if v24 and (v24.collectibleItemId ~= nil and v25 ~= nil) then
			v30 = v25[v24.collectibleItemId]
		end

		if v24 then
			if v21 == ItemTypeEnum.Asset then
				return (convertAssetInfoToItemData(v24, v30))
			end

			if v21 == ItemTypeEnum.Bundle then
				return (convertBundleInfoToItemData(v24, v30))
			end
		end

		return nil
	end, {
		v24,
		v25,
		v21
	}), v26
end

return useConvertedItemData
