local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local AssetInfo = require(ParentParent.Models.AssetInfo)
local SetAssets = require(ParentParent.Actions.SetAssets)
local SetBundlesAssetIsPartOf = require(ParentParent.Actions.SetBundlesAssetIsPartOf)
local SetAssetFromBundleInfo = require(ParentParent.Actions.SetAssetFromBundleInfo)
local SetAvatarPreviewDetails = require(ParentParent.Actions.SetAvatarPreviewDetails)
local SetFavoriteAsset = require(ParentParent.Actions.SetFavoriteAsset)
local UpdateBulkPuchaseResults = require(ParentParent.Actions.UpdateBulkPuchaseResults)
local ItemTypeEnum = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.ItemTypeEnum
local FFlagAXEnableFetchAvatarPreview = require(ParentParent.Flags.FFlagAXEnableFetchAvatarPreview)
local FFlagAXEnableInspectAndBuyBulkPurchase = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXEnableInspectAndBuyBulkPurchase
local FFlagAXEnableFavoritesInfoForAssetsAndBundles = require(ParentParent.Flags.FFlagAXEnableFavoritesInfoForAssetsAndBundles)

return Rodux.createReducer({}, {
	[SetFavoriteAsset.name] = if not FFlagAXEnableFavoritesInfoForAssetsAndBundles then nil else function(p1, p2) -- line: 26
		-- upvalues: Cryo (copy), AssetInfo (copy)
		local v18 = p1[p2.id] or {}
		local v19 = Cryo.Dictionary.join({}, v18)

		p1[p2.id] = Cryo.Dictionary.join(v19, AssetInfo.fromGetFavoriteForAsset(p2.id, p2.isFavorite))

		return p1
	end,
	[UpdateBulkPuchaseResults.name] = if not FFlagAXEnableInspectAndBuyBulkPurchase then nil else function(p3, p4) -- line: 38
		-- upvalues: Cryo (copy), AssetInfo (copy)
		for _, v23 in p4.result.Items do
			if v23.type == Enum.MarketplaceProductType.AvatarAsset then
				local v24 = Cryo.Dictionary.join({}, p3[v23.id])

				p3[v23.id] = Cryo.Dictionary.join(v24, AssetInfo.fromBulkPurchaseResult(v23, v24))
			end
		end

		return p3
	end,
	[SetAssets.name] = function(p5, p6) -- line: 53
		-- upvalues: Cryo (copy), AssetInfo (copy)
		local t1 = {}

		for _, v in ipairs(p6.assets) do
			assert(v.assetId ~= nil, "Expected an asset id when setting an asset's information.")

			local v30 = p5[v.assetId] or {}

			t1[v.assetId] = Cryo.Dictionary.join(v30, v)

			if t1[v.assetId] then
				t1[v.assetId] = AssetInfo.getSaleDetailsForCollectibles(t1[v.assetId])
			end
		end

		return (Cryo.Dictionary.join(p5, t1))
	end,
	[SetAvatarPreviewDetails.name] = if not FFlagAXEnableFetchAvatarPreview then nil else function(p7, p8) -- line: 74
		-- upvalues: ItemTypeEnum (copy), AssetInfo (copy), Cryo (copy)
		local look = p8.avatarPreviewDetails.look

		if look.items then
			local t2 = {}

			for _, v36 in look.items do
				if v36.itemType == ItemTypeEnum.Asset then
					t2[tostring(v36.id)] = AssetInfo.fromAvatarPreviewItem(v36)
				end
			end

			return Cryo.Dictionary.join(p7, t2)
		end

		return p7
	end,
	[SetBundlesAssetIsPartOf.name] = function(p9, p10) -- line: 95
		-- upvalues: AssetInfo (copy), Cryo (copy)
		local str = tostring(p10.assetId)
		local bundleIds = p10.bundleIds
		local v41 = p9[str] or {}
		local v42 = AssetInfo.fromGetAssetBundles(str, bundleIds)
		local v43 = Cryo.Dictionary.join(v41, v42)

		return Cryo.Dictionary.join(p9, {
			[str] = v43
		})
	end,
	[SetAssetFromBundleInfo.name] = function(p11, p12) -- line: 104
		-- upvalues: AssetInfo (copy), Cryo (copy)
		local bundleInfo = p12.bundleInfo
		local str = tostring(p12.assetId)
		local v48 = p11[str] or {}
		local v49 = AssetInfo.fromBundleInfo(str, bundleInfo)
		local v50 = Cryo.Dictionary.join(v48, v49)

		return Cryo.Dictionary.join(p11, {
			[str] = v50
		})
	end
})
