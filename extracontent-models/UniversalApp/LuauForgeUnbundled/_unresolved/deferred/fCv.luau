local module = require("@luauforge/bundled/dPN")
local module2 = require("@luauforge/bundled/dPU")
local itemData = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").State.Selectors.ItemData
local module3 = require("@luauforge/bundled/dVl")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").getAppFeaturePolicies

local v5 = memoize(function(data, p2, p3, p4, p5, p6)
	assert(data, "silence type checker")
	local isOwned = data.isOwned
	local isPurchasable = data.isPurchasable
	local isResellable = module3.IsResellable(data)
	local isForRent = data.isForRent
	local collectibleItemId = data.collectibleItemId
	local isPurchasable2 = data.timedOptions and data.isPurchasable
	local v6 = isResellable and p2 == nil
	local v7 = module2.ResaleRestriction.None
	local v8 = true
	local v9 = true
	local v10 = not (isOwned or isPurchasable) or v6 or isForRent or p3 == nil
	local v11 = nil

	if collectibleItemId then
		local v12 = p4[collectibleItemId]

		if isResellable then
			if p6 and v12 then
				v12.resaleRestriction = module2.ResaleRestriction.Disabled
			end

			local hasResellers = v12 and v12.hasResellers

			v7 = if v12 then v12.resaleRestriction else module2.ResaleRestriction.None

			v9 = v12 and v12.unitsAvailableForConsumption and v12.unitsAvailableForConsumption > 0

			v8 = module3.isCollectibleSellableInShop(v12)

			v11 = not hasResellers and module3.reachQuantityLimit(v12, p5)

			v10 = not v8 or isForRent or p3 == nil or v11
		elseif v12 then
			v10 = v10 or not module3.isOriginalStockSellableInShop(v12)
		end
	end

	if isOwned then
		if not isResellable or not v8 or v11 then
			v11 = not isPurchasable2
		end
	else
		v11 = isOwned
	end

	local assetType = data.assetType

	if assetType and module.AssetTypeIdStringToName[assetType] == nil and v11 then
		v11 = false
		v10 = true
	end

	if v11 then
		return module.ItemPromptType.OpenGoToAvatarEditorPrompt
	end

	if collectibleItemId and v7 == module2.ResaleRestriction.Disabled and not v9 then
		return module.ItemPromptType.SoldOut
	end

	if v10 then
		return module.ItemPromptType.Disabled
	end

	return module.ItemPromptType.OpenPurchasePrompt
end)

return function(data, p2, p3, p4)
	local v6 = itemData(data.AvatarExperience.Common, p2, p3)

	if not v6 then
		return module.ItemPromptType.Disabled
	end

	assert(v6, "silence type checker")
	local resellerUserAssetIds = v6.resellerUserAssetIds
	local collectibleItemId = v6.collectibleItemId

	local v7 = resellerUserAssetIds and resellerUserAssetIds[1]
	local userAsset = data.AvatarExperience.Catalog.UserAssets[v7]
	local v8 = data.UserRobux[data.LocalUserId]
	local collectiblesItemInfo = data.AvatarExperience.Common.Collectibles.CollectiblesItemInfo
	local v9

	if collectibleItemId then
		v9 = data.AvatarExperience.Common.Collectibles.CollectiblesResellableInstances[collectibleItemId]
	end

	local v10 = if p4 and p4.DisableResellingCollectiblesForCompliance then p4.DisableResellingCollectiblesForCompliance else getAppFeaturePolicies().getDisableResellingCollectiblesForCompliance()

	return v5(v6, userAsset, v8, collectiblesItemInfo, v9, v10)
end
