local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local SetBundles = require(ParentParent.Actions.SetBundles)
local SetFavoriteBundle = require(ParentParent.Actions.SetFavoriteBundle)
local UpdateBulkPuchaseResults = require(ParentParent.Actions.UpdateBulkPuchaseResults)
local SetAvatarPreviewDetails = require(ParentParent.Actions.SetAvatarPreviewDetails)
local ItemTypeEnum = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.ItemTypeEnum
local FFlagAXEnableFetchAvatarPreview = require(ParentParent.Flags.FFlagAXEnableFetchAvatarPreview)
local FFlagAXEnableInspectAndBuyBulkPurchase = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXEnableInspectAndBuyBulkPurchase
local FFlagAXEnableFavoritesInfoForAssetsAndBundles = require(ParentParent.Flags.FFlagAXEnableFavoritesInfoForAssetsAndBundles)
local BundleInfo = require(ParentParent.Models.BundleInfo)

return Rodux.createReducer({}, {
	[SetFavoriteBundle.name] = if not FFlagAXEnableFavoritesInfoForAssetsAndBundles then nil else function(p1, p2) -- line: 35
		-- upvalues: Cryo (copy), BundleInfo (copy)
		local v16 = p1[p2.id] or {}
		local v17 = Cryo.Dictionary.join({}, v16)

		p1[p2.id] = Cryo.Dictionary.join(v17, BundleInfo.fromGetFavoriteForAsset(p2.id, p2.isFavorite))

		return p1
	end,
	[UpdateBulkPuchaseResults.name] = if not FFlagAXEnableInspectAndBuyBulkPurchase then nil else function(p3, p4) -- line: 47
		-- upvalues: Cryo (copy), BundleInfo (copy)
		for _, v21 in p4.result.Items do
			if v21.type == Enum.MarketplaceProductType.AvatarBundle then
				local v22 = Cryo.Dictionary.join({}, p3[v21.id])

				p3[v21.id] = Cryo.Dictionary.join(v22, BundleInfo.fromBulkPurchaseResult(v21, v22))
			end
		end

		return p3
	end,
	[SetAvatarPreviewDetails.name] = if not FFlagAXEnableFetchAvatarPreview then nil else function(p5, p6) -- line: 63
		-- upvalues: ItemTypeEnum (copy), BundleInfo (copy), Cryo (copy)
		local look = p6.avatarPreviewDetails.look
		local t1 = {}

		if look.items then
			for _, v28 in look.items do
				if v28.itemType == ItemTypeEnum.Bundle then
					t1[tostring(v28.id)] = BundleInfo.fromAvatarPreviewItem(v28)
				end
			end
		end

		return Cryo.Dictionary.join(p5, t1)
	end,
	[SetBundles.name] = function(p7, p8) -- line: 80
		-- upvalues: FFlagAXEnableFavoritesInfoForAssetsAndBundles (copy), Cryo (copy), BundleInfo (copy)
		local t2 = {}

		for _, v in ipairs(p8.bundles) do
			assert(v.bundleId ~= nil, "Expected a bundle id when setting a bundle's information.")

			local v34 = p7[v.bundleId] or {}

			if FFlagAXEnableFavoritesInfoForAssetsAndBundles and v.assetsInBundle then
				local t3 = {}

				for _, v37 in v.assetsInBundle do
					for _, v39 in v34.assetsInBundle or {} do
						if v39.id == v37.id then
							table.insert(t3, (Cryo.Dictionary.join(v39, v37)))

							break
						end
					end
				end

				v.assetsInBundle = t3
			end

			t2[v.bundleId] = Cryo.Dictionary.join(v34, v)

			if t2[v.bundleId] then
				t2[v.bundleId] = BundleInfo.getSaleDetailsForCollectibles(t2[v.bundleId])
			end
		end

		return Cryo.Dictionary.join(p7, t2)
	end
})
