local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module = require("@luauforge/bundled/dVl")
require("@luauforge/bundled/dQF")
local module2 = require("@luauforge/bundled/dPU")
require("@luauforge/bundled/dPs")
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

	local v7 = useSelector(React.useCallback(function(p4)
		if collectibleItemId then
			return p4.AvatarExperience.Common.Collectibles.CollectiblesItemInfo[collectibleItemId]
		end

		return nil
	end, { collectibleItemId }), getUseSelectorDeepEquals())

	local v9 = useSelector(React.useCallback(function(p4)
		if not limitedCollectible then
			return nil
		end

		if collectibleItemId then
			return p4.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[collectibleItemId]
		end

		return nil
	end, { collectibleItemId, limitedCollectible }), getUseSelectorDeepEquals())

	local v10 = module.IsResellable(v5) or false
	local isTradable = module.getIsTradable(v5)
	local hasAttribution = module.HasAttribution(v5)
	local v11 = 0
	local v12 = false
	local v13 = false
	local v14 = if v5 and v5.resellerUserAssetIds then #v5.resellerUserAssetIds > 0 else false

	local v15 = not (v5 and v5.soldCount) and 0 or v5.soldCount
	local v16 = not (v5 and v5.totalQuantity) and 0 or v5.totalQuantity
	local v17 = not (v5 and v5.originalPrice) and 0 or v5.originalPrice
	local v18 = not (v5 and v5.averagePrice) and 0 or v5.averagePrice
	local v19 = module2.ResaleRestriction.None

	if v7 then
		v19 = if v7.resaleRestriction then v7.resaleRestriction else module2.ResaleRestriction.None
		v14 = if v7.hasResellers then v7.hasResellers else false
		local assetStock = v7.assetStock or 0
		local unitsAvailableForConsumption = v7.unitsAvailableForConsumption or 0
		v15 = not (assetStock and unitsAvailableForConsumption) and 0
			or assetStock - unitsAvailableForConsumption
		v17 = v7.price or 0
		v18 = v7.recentAveragePrice or 0
		v16 = v7.assetStock or 0
		v11 = v7.quantityLimitPerUser or 0
		v13 = module.reachQuantityLimit(v7, v9)
		v12 = module.shouldShowQuantityLimit(v11)
	end

	local v20 = v15 < v16 and module.isOriginalStockSellableInShop(v7)

	local isHighDefinition = if fFlagAXAddHDRowInItemDetailsPage then v5 and v5.isHighDefinition else nil
	local isPBR = v5 and v5.isPBR
	local renderProperties = v5 and v5.renderProperties

	if not fFlagAXAddHDRowInItemDetailsPage then
		isHighDefinition = nil
	end

	return {
		averagePrice = v18,
		hasResellers = v14,
		isResellable = v10,
		hasAttribution = hasAttribution,
		isStockAvailable = v20,
		isTradable = isTradable,
		itemStock = v16,
		originalPrice = v17,
		collectiblesResaleRestriction = v19,
		quantityLimit = v11,
		reachedQuantityLimit = v13,
		shouldShowQuantityLimit = v12,
		soldCount = v15,
		isHighDefinition = isHighDefinition,
		isPBR = isPBR,
		renderProperties = renderProperties
	}
end

return useItemDataDigest
