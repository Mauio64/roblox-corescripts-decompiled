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

return Rodux.createReducer({}, {
	[SetFavoriteAsset.name] = function(p1, p2) -- line: 23
		-- upvalues: Cryo (copy), AssetInfo (copy)
		local v17 = p1[p2.id] or {}
		local v18 = Cryo.Dictionary.join({}, v17)

		p1[p2.id] = Cryo.Dictionary.join(v18, AssetInfo.fromGetFavoriteForAsset(p2.id, p2.isFavorite))

		return p1
	end,
	[UpdateBulkPuchaseResults.name] = if not FFlagAXEnableInspectAndBuyBulkPurchase then nil else function(p3, p4) -- line: 34
		-- upvalues: Cryo (copy), AssetInfo (copy)
		for _, v22 in p4.result.Items do
			if v22.type == Enum.MarketplaceProductType.AvatarAsset then
				local v23 = Cryo.Dictionary.join({}, p3[v22.id])

				p3[v22.id] = Cryo.Dictionary.join(v23, AssetInfo.fromBulkPurchaseResult(v22, v23))
			end
		end

		return p3
	end,
	[SetAssets.name] = function(p5, p6) -- line: 49
		-- upvalues: Cryo (copy), AssetInfo (copy)
		local t1 = {}

		for _, v in ipairs(p6.assets) do
			assert(v.assetId ~= nil, "Expected an asset id when setting an asset's information.")

			local v29 = p5[v.assetId] or {}

			t1[v.assetId] = Cryo.Dictionary.join(v29, v)

			if t1[v.assetId] then
				t1[v.assetId] = AssetInfo.getSaleDetailsForCollectibles(t1[v.assetId])
			end
		end

		return (Cryo.Dictionary.join(p5, t1))
	end,
	[SetAvatarPreviewDetails.name] = if not FFlagAXEnableFetchAvatarPreview then nil else function(p7, p8) -- line: 70
		-- upvalues: ItemTypeEnum (copy), AssetInfo (copy), Cryo (copy)
		local look = p8.avatarPreviewDetails.look

		if look.items then
			local t2 = {}

			for _, v35 in look.items do
				if v35.itemType == ItemTypeEnum.Asset then
					t2[tostring(v35.id)] = AssetInfo.fromAvatarPreviewItem(v35)
				end
			end

			return Cryo.Dictionary.join(p7, t2)
		end

		return p7
	end,
	[SetBundlesAssetIsPartOf.name] = function(p9, p10) -- line: 91
		-- upvalues: AssetInfo (copy), Cryo (copy)
		local str = tostring(p10.assetId)
		local bundleIds = p10.bundleIds
		local v40 = p9[str] or {}
		local v41 = AssetInfo.fromGetAssetBundles(str, bundleIds)
		local v42 = Cryo.Dictionary.join(v40, v41)

		return Cryo.Dictionary.join(p9, {
			[str] = v42
		})
	end,
	[SetAssetFromBundleInfo.name] = function(p11, p12) -- line: 100
		-- upvalues: AssetInfo (copy), Cryo (copy)
		local bundleInfo = p12.bundleInfo
		local str = tostring(p12.assetId)
		local v47 = p11[str] or {}
		local v48 = AssetInfo.fromBundleInfo(str, bundleInfo)
		local v49 = Cryo.Dictionary.join(v47, v48)

		return Cryo.Dictionary.join(p11, {
			[str] = v49
		})
	end
})
