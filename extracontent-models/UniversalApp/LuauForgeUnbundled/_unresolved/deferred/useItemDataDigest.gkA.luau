local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module = require("@luauforge/bundled/dRQ")
require("@luauforge/bundled/dNp")
local module2 = require("@luauforge/bundled/dME")
require("@luauforge/bundled/dMc")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local itemData = AvatarExperienceCommon.State.Selectors.ItemData

local fFlagAXAddHDRowInItemDetailsPage = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAddHDRowInItemDetailsPage

local function useItemDataDigest(p2, p3)
	local v5 = useSelector(function(p4)
		return itemData(p4.AvatarExperience.Common, p2, p3)
	end, getUseSelectorDeepEquals())

	local collectibleItemId = if v5 then v5.collectibleItemId else nil
	local limitedCollectible = module.isLimitedCollectible(v5)

	local v6 = useSelector(React.useCallback(function(p4)
		if collectibleItemId then
			return p4.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[collectibleItemId]
		end

		return nil
	end, { collectibleItemId }), getUseSelectorDeepEquals())

	local v7 = useSelector(React.useCallback(function(p4)
		if not limitedCollectible then
			return nil
		end

		if collectibleItemId then
			return p4.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[collectibleItemId]
		end

		return nil
	end, { collectibleItemId, limitedCollectible }), getUseSelectorDeepEquals())

	local v8 = module.IsResellable(v5) or false
	local isTradable = module.getIsTradable(v5)
	local hasAttribution = module.HasAttribution(v5)
	local v9 = 0
	local v10 = false
	local v11 = false
	local v12 = if v5 and v5.resellerUserAssetIds then #v5.resellerUserAssetIds > 0 else false

	local v13 = not (v5 and v5.soldCount) and 0 or v5.soldCount
	local v14 = not (v5 and v5.totalQuantity) and 0 or v5.totalQuantity
	local v15 = not (v5 and v5.originalPrice) and 0 or v5.originalPrice
	local v16 = not (v5 and v5.averagePrice) and 0 or v5.averagePrice
	local v17 = module2.ResaleRestriction.None

	if v6 then
		v17 = if v6.resaleRestriction then v6.resaleRestriction else module2.ResaleRestriction.None
		v12 = if v6.hasResellers then v6.hasResellers else false
		local assetStock = v6.assetStock or 0
		local unitsAvailableForConsumption = v6.unitsAvailableForConsumption or 0
		v13 = not (assetStock and unitsAvailableForConsumption) and 0
			or assetStock - unitsAvailableForConsumption
		v15 = v6.price or 0
		v16 = v6.recentAveragePrice or 0
		v14 = v6.assetStock or 0
		v9 = v6.quantityLimitPerUser or 0
		v11 = module.reachQuantityLimit(v6, v7)
		v10 = module.shouldShowQuantityLimit(v9)
	end

	local v18 = v13 < v14 and module.isOriginalStockSellableInShop(v6)

	local isHighDefinition = if fFlagAXAddHDRowInItemDetailsPage then v5 and v5.isHighDefinition else nil
	local isPBR = v5 and v5.isPBR
	local renderProperties = v5 and v5.renderProperties

	if not fFlagAXAddHDRowInItemDetailsPage then
		isHighDefinition = nil
	end

	return {
		averagePrice = v16,
		hasResellers = v12,
		isResellable = v8,
		hasAttribution = hasAttribution,
		isStockAvailable = v18,
		isTradable = isTradable,
		itemStock = v14,
		originalPrice = v15,
		collectiblesResaleRestriction = v17,
		quantityLimit = v9,
		reachedQuantityLimit = v11,
		shouldShowQuantityLimit = v10,
		soldCount = v13,
		isHighDefinition = isHighDefinition,
		isPBR = isPBR,
		renderProperties = renderProperties
	}
end

return useItemDataDigest
