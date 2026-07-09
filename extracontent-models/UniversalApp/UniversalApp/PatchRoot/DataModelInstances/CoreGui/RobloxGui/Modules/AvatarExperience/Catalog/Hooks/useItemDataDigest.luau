local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)

require(Modules.AvatarExperience.Common.Models.CollectibleInfo)

local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)

require(Modules.AvatarExperience.Common.Types)

local getUseSelectorDeepEquals = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.getUseSelectorDeepEquals
local FFlagAXAddHDRowInItemDetailsPage = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAddHDRowInItemDetailsPage

local function useItemDataDigest(s1: string, s2: string) -- line: 29
	-- upvalues: useSelector (copy), ItemData (copy), getUseSelectorDeepEquals (copy), CatalogUtils (copy), React (copy), CatalogConstants (copy), FFlagAXAddHDRowInItemDetailsPage (copy)
	local v13 = useSelector(function(p1) -- line: 30
		-- upvalues: ItemData (copy), s1 (copy), s2 (copy)
		return ItemData(p1.AvatarExperience.Common, s1, s2)
	end, getUseSelectorDeepEquals())
	local v14 = if not v13 then nil else v13.collectibleItemId
	local v15 = CatalogUtils.isLimitedCollectible(v13)
	local v16 = React.useCallback(function(p2) -- line: 37
		-- upvalues: v14 (copy)
		if v14 then
			return p2.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[v14]
		end

		return nil
	end, { v14 })
	local v17 = useSelector(v16, getUseSelectorDeepEquals())
	local v18 = React.useCallback(function(p3) -- line: 44
		-- upvalues: v15 (copy), v14 (copy)
		if not v15 then
			return nil
		end

		if v14 then
			return p3.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[v14]
		end

		return nil
	end, {
		v14,
		v15
	})
	local v19 = useSelector(v18, getUseSelectorDeepEquals())
	local v20 = CatalogUtils.IsResellable(v13) or false
	local v21 = CatalogUtils.getIsTradable(v13)
	local v22 = CatalogUtils.HasAttribution(v13)
	local n1 = 0
	local v24 = false
	local v25 = false
	local v26 = not not v13 and (not not v13.resellerUserAssetIds and #v13.resellerUserAssetIds > 0)
	local v27 = (not v13 or not v13.soldCount) and 0 or v13.soldCount
	local v28 = (not v13 or not v13.totalQuantity) and 0 or v13.totalQuantity
	local v29 = (not v13 or not v13.originalPrice) and 0 or v13.originalPrice
	local v30 = (not v13 or not v13.averagePrice) and 0 or v13.averagePrice
	local None = CatalogConstants.ResaleRestriction.None

	if v17 then
		None = if not v17.resaleRestriction then CatalogConstants.ResaleRestriction.None else v17.resaleRestriction
		v26 = not not v17.hasResellers and v17.hasResellers

		local v32 = v17.assetStock or 0
		local v33 = v17.unitsAvailableForConsumption or 0

		v27 = (not v32 or not v33) and 0 or v32 - v33
		v29 = v17.price or 0
		v30 = v17.recentAveragePrice or 0
		v28 = v17.assetStock or 0
		n1 = v17.quantityLimitPerUser or 0
		v25 = CatalogUtils.reachQuantityLimit(v17, v19)
		v24 = CatalogUtils.shouldShowQuantityLimit(n1)
	end

	local v34 = v27 < v28 and CatalogUtils.isOriginalStockSellableInShop(v17)
	local v35 = if not FFlagAXAddHDRowInItemDetailsPage then nil else v13 and v13.isHighDefinition
	local v36 = v13 and v13.isPBR

	return {
		averagePrice = v30,
		hasResellers = v26,
		isResellable = v20,
		hasAttribution = v22,
		isStockAvailable = v34,
		isTradable = v21,
		itemStock = v28,
		originalPrice = v29,
		collectiblesResaleRestriction = None,
		quantityLimit = n1,
		reachedQuantityLimit = v25,
		shouldShowQuantityLimit = v24,
		soldCount = v27,
		isHighDefinition = if not FFlagAXAddHDRowInItemDetailsPage then nil else v35,
		isPBR = v36
	}
end

return useItemDataDigest
