local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent
local SetBundles = require(parent.Actions.SetBundles)
local SetFavoriteBundle = require(parent.Actions.SetFavoriteBundle)
local UpdateBulkPuchaseResults = require(parent.Actions.UpdateBulkPuchaseResults)
local SetAvatarPreviewDetails = require(parent.Actions.SetAvatarPreviewDetails)
local AvatarExperienceModel = require(CorePackages.Workspace.Packages.AvatarExperienceModel)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local FFlagAXEnableFetchAvatarPreview = require(parent.Flags.FFlagAXEnableFetchAvatarPreview)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAXEnableInspectAndBuyBulkPurchase = SharedFlags.FFlagAXEnableInspectAndBuyBulkPurchase

local BundleInfo = require(parent.Models.BundleInfo)

return Rodux.createReducer({}, {
	[SetFavoriteBundle.name] = function(values, p)
		local v = values[p.id] or {}
		local joined = Cryo.Dictionary.join({}, v)
		values[p.id] = Cryo.Dictionary.join(joined, BundleInfo.fromGetFavoriteForAsset(p.id, p.isFavorite))
		return values
	end,
	[UpdateBulkPuchaseResults.name] = FFlagAXEnableInspectAndBuyBulkPurchase and function(values, p)
		for _, item in p.result.Items do
			if item.type ~= Enum.MarketplaceProductType.AvatarBundle then
				continue
			end

			local joined = Cryo.Dictionary.join({}, values[item.id])
			values[item.id] = Cryo.Dictionary.join(joined, BundleInfo.fromBulkPurchaseResult(item, joined))
		end

		return values
	end or nil,
	[SetAvatarPreviewDetails.name] = FFlagAXEnableFetchAvatarPreview and function(p, p2)
		local look = p2.avatarPreviewDetails.look
		local v = {}

		if look.items then
			for _, item in look.items do
				if item.itemType == ItemTypeEnum.Bundle then
					v[tostring(item.id)] = BundleInfo.fromAvatarPreviewItem(item)
				end
			end
		end

		return Cryo.Dictionary.join(p, v)
	end or nil,
	[SetBundles.name] = function(p, p2)
		local v = {}

		for _, bundle in ipairs(p2.bundles) do
			assert(bundle.bundleId ~= nil, "Expected a bundle id when setting a bundle's information.")
			local v2 = p[bundle.bundleId] or {}

			if bundle.assetsInBundle then
				local values = {}

				for _, v3 in bundle.assetsInBundle do
					for _, v4 in v2.assetsInBundle or {} do
						if v4.id == v3.id then
							table.insert(values, (Cryo.Dictionary.join(v4, v3)))
							break
						end
					end
				end

				bundle.assetsInBundle = values
			end

			v[bundle.bundleId] = Cryo.Dictionary.join(v2, bundle)

			if v[bundle.bundleId] then
				v[bundle.bundleId] = BundleInfo.getSaleDetailsForCollectibles(v[bundle.bundleId])
			end
		end

		return Cryo.Dictionary.join(p, v)
	end
})
