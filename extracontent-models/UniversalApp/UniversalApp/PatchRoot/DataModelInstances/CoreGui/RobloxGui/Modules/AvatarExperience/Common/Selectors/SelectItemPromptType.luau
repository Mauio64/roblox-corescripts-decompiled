local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local ItemData = require(Modules.AvatarExperience.Common.Selectors.ItemData)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies
local v9 = memoize(function(p1, p2, p3, p4, p5, p6) -- line: 12
	-- upvalues: CatalogUtils (copy), CatalogConstants (copy), Constants (copy)
	assert(p1, "silence type checker")

	local isOwned = p1.isOwned
	local isPurchasable = p1.isPurchasable
	local v18 = CatalogUtils.IsResellable(p1)
	local isForRent = p1.isForRent
	local collectibleItemId = p1.collectibleItemId
	local v21 = p1.timedOptions and p1.isPurchasable
	local v22 = v18 and p2 == nil
	local None = CatalogConstants.ResaleRestriction.None
	local v24 = true
	local v25 = true
	local v26 = not isOwned and not isPurchasable or (v22 or (isForRent or p3 == nil))
	local v27 = nil

	if collectibleItemId then
		local v28 = p4[collectibleItemId]

		if v18 then
			if p6 and v28 then
				v28.resaleRestriction = CatalogConstants.ResaleRestriction.Disabled
			end

			local v29 = v28 and v28.hasResellers

			None = if not v28 then CatalogConstants.ResaleRestriction.None else v28.resaleRestriction
			v25 = v28 and (v28.unitsAvailableForConsumption and v28.unitsAvailableForConsumption > 0)
			v24 = CatalogUtils.isCollectibleSellableInShop(v28)
			v27 = not v29 and CatalogUtils.reachQuantityLimit(v28, p5)
			v26 = not v24 or (isForRent or (p3 == nil or v27))
		elseif v28 then
			v26 = v26 or not CatalogUtils.isOriginalStockSellableInShop(v28)
		end
	end

	local v30 = isOwned and ((not v18 or (not v24 or v27)) and not v21)
	local assetType = p1.assetType

	if assetType and Constants.AssetTypeIdStringToName[assetType] == nil and v30 then
		v26 = true
		v30 = false
	end

	if v30 then
		return Constants.ItemPromptType.OpenGoToAvatarEditorPrompt
	end

	if collectibleItemId and None == CatalogConstants.ResaleRestriction.Disabled and not v25 then
		return Constants.ItemPromptType.SoldOut
	end

	if v26 then
		return Constants.ItemPromptType.Disabled
	end

	return Constants.ItemPromptType.OpenPurchasePrompt
end)

return function(p7, p8, p9, p10) -- line: 106
	-- upvalues: ItemData (copy), Constants (copy), getAppFeaturePolicies (copy), v9 (copy)
	local v36 = ItemData(p7.AvatarExperience.Common, p8, p9)

	if not v36 then
		return Constants.ItemPromptType.Disabled
	end

	assert(v36, "silence type checker")

	local resellerUserAssetIds = v36.resellerUserAssetIds
	local collectibleItemId = v36.collectibleItemId
	local v39 = resellerUserAssetIds and resellerUserAssetIds[1]
	local v40 = p7.AvatarExperience.Catalog.UserAssets[v39]
	local v41 = p7.UserRobux[p7.LocalUserId]
	local CollectiblesItemInfo = p7.AvatarExperience.Common.Collectibles.CollectiblesItemInfo
	local v43 = nil

	if collectibleItemId then
		v43 = p7.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[collectibleItemId]
	end

	local v44 = if not p10 or not p10.DisableResellingCollectiblesForCompliance then getAppFeaturePolicies().getDisableResellingCollectiblesForCompliance() else p10.DisableResellingCollectiblesForCompliance

	return v9(v36, v40, v41, CollectiblesItemInfo, v43, v44)
end
