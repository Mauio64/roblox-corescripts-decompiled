local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent
local AssetInfo = require(parent.Models.AssetInfo)
local SetAssets = require(parent.Actions.SetAssets)
local SetBundlesAssetIsPartOf = require(parent.Actions.SetBundlesAssetIsPartOf)
local SetAssetFromBundleInfo = require(parent.Actions.SetAssetFromBundleInfo)
local SetAvatarPreviewDetails = require(parent.Actions.SetAvatarPreviewDetails)
local SetFavoriteAsset = require(parent.Actions.SetFavoriteAsset)
local UpdateBulkPuchaseResults = require(parent.Actions.UpdateBulkPuchaseResults)
local AvatarExperienceModel = require(CorePackages.Workspace.Packages.AvatarExperienceModel)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum
local FFlagAXEnableFetchAvatarPreview = require(parent.Flags.FFlagAXEnableFetchAvatarPreview)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAXEnableInspectAndBuyBulkPurchase = SharedFlags.FFlagAXEnableInspectAndBuyBulkPurchase

return Rodux.createReducer({}, {
	[SetFavoriteAsset.name] = function(values, p)
		local v = values[p.id] or {}
		local joined = Cryo.Dictionary.join({}, v)
		values[p.id] = Cryo.Dictionary.join(joined, AssetInfo.fromGetFavoriteForAsset(p.id, p.isFavorite))
		return values
	end,
	[UpdateBulkPuchaseResults.name] = FFlagAXEnableInspectAndBuyBulkPurchase and function(values, p)
		for _, item in p.result.Items do
			if item.type ~= Enum.MarketplaceProductType.AvatarAsset then
				continue
			end

			local joined = Cryo.Dictionary.join({}, values[item.id])
			values[item.id] = Cryo.Dictionary.join(joined, AssetInfo.fromBulkPurchaseResult(item, joined))
		end

		return values
	end or nil,
	[SetAssets.name] = function(p, p2)
		local v = {}

		for _, asset in ipairs(p2.assets) do
			assert(asset.assetId ~= nil, "Expected an asset id when setting an asset's information.")
			local v2 = p[asset.assetId] or {}
			v[asset.assetId] = Cryo.Dictionary.join(v2, asset)

			if v[asset.assetId] then
				v[asset.assetId] = AssetInfo.getSaleDetailsForCollectibles(v[asset.assetId])
			end
		end

		return (Cryo.Dictionary.join(p, v))
	end,
	[SetAvatarPreviewDetails.name] = FFlagAXEnableFetchAvatarPreview and function(p, p2)
		local look = p2.avatarPreviewDetails.look

		if not look.items then
			return p
		end

		local v = {}

		for _, item in look.items do
			if item.itemType == ItemTypeEnum.Asset then
				v[tostring(item.id)] = AssetInfo.fromAvatarPreviewItem(item)
			end
		end

		return Cryo.Dictionary.join(p, v)
	end or nil,
	[SetBundlesAssetIsPartOf.name] = function(p, p2)
		local assetId = tostring(p2.assetId)
		local bundleIds = p2.bundleIds
		local v = p[assetId] or {}
		local v2 = AssetInfo.fromGetAssetBundles(assetId, bundleIds)
		local joined = Cryo.Dictionary.join(v, v2)
		return Cryo.Dictionary.join(p, { [assetId] = joined })
	end,
	[SetAssetFromBundleInfo.name] = function(p, p2)
		local bundleInfo = p2.bundleInfo
		local assetId = tostring(p2.assetId)
		local v = p[assetId] or {}
		local v2 = AssetInfo.fromBundleInfo(assetId, bundleInfo)
		local joined = Cryo.Dictionary.join(v, v2)

		return Cryo.Dictionary.join(p, { [assetId] = joined })
	end
})
