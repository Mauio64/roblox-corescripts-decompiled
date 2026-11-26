local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dzP")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
require("@luauforge/bundled/dKU")

local module5 = require("@luauforge/bundled/dPM")
local module6 = require("@luauforge/bundled/dPW")

local module7 = require("@luauforge/bundled/dPX")

local module8 = require("@luauforge/bundled/dPY")

local module9 = require("@luauforge/bundled/dPZ")

local module10 = require("@luauforge/bundled/dQa")

local SetAssets = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Actions/SetAssets")
local module12 = require("@luauforge/bundled/dQc")
local module13 = require("@luauforge/bundled/dQd")

local module14 = require("@luauforge/bundled/dQe")
local module15 = require("@luauforge/bundled/dQf")
local module16 = require("@luauforge/bundled/dQg")
local module17 = require("@luauforge/bundled/dQh")
local module18 = require("@luauforge/bundled/dQi")
local module19 = require("@luauforge/bundled/dQj")
local module20 = require("@luauforge/bundled/dQk")
local module21 = require("@luauforge/bundled/dPN")
local module22 = require("@luauforge/bundled/dQl")
local module23 = require("@luauforge/bundled/dQm")
local SetTryingOnInfo = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Actions/SetTryingOnInfo")
local module25 = require("@luauforge/bundled/dQo")
local module26 = require("@luauforge/bundled/dQp")
require("@luauforge/bundled/dPs")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local module27 = require("@luauforge/bundled/dQq")
local purchaseItemsSuccess = AvatarExperienceCatalog.State.Actions.PurchaseItemsSuccess
local fetchAssetOrBundleInfoBatchedSuccess = AvatarExperienceCatalog.State.Actions.FetchAssetOrBundleInfoBatchedSuccess

local module28 = require("@luauforge/bundled/dQr")
local axRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest

local module29 = require("@luauforge/bundled/dQs")
local module30 = require("@luauforge/bundled/dQt")

local fFlagAXSubscriptionRefetchEvictStores = AvatarExperienceFlags.FFlagAXSubscriptionRefetchEvictStores

local fFlagAXPopulateSupportsHeadShapesFromAvatarData = AvatarExperienceFlags.FFlagAXPopulateSupportsHeadShapesFromAvatarData

return Rodux.createReducer({}, {
	[module10.name] = function(p2, p3)
		module.isType(p3.assetId, "string", "assetId must be a string.")
		module.isType(p3.assetData, "table", "assetData must be a table.")

		local assetId = tostring(p3.assetId)
		local v6 = p2[assetId]
		local v7 = module5.fromGetCatalogItemData(p3.assetData, v6)
		return Cryo.Dictionary.join(p2, { [assetId] = v7 })
	end,
	[SetAssets.name] = function(p2, p3)
		module.isType(p3.assets, "table", "assets data must be a table.")

		local v6 = {}

		for k, asset in p3.assets do
			local id = tostring(asset.id)
			local v7 = p2[id]
			v6[id] = module5.fromBundleItemData(asset, v7)
		end

		return Cryo.Dictionary.join(p2, v6)
	end,
	[module12.name] = function(p2, p3)
		module.isType(p3.sortResults, "table", "sortResults must be a table.")

		local v6 = {}

		for k, sortResult in p3.sortResults do
			local id = tostring(sortResult.id)
			local v7 = p2[id]
			v6[id] = module5.fromSortResults(sortResult, v7)
		end

		return Cryo.Dictionary.join(p2, v6)
	end,
	[module13.name] = function(p2, p3)
		local v6 = {}

		for k, sortResult in p3.sortResults do
			if not sortResult.bundledItems then
				continue
			end

			for k2, bundledItem in sortResult.bundledItems do
				if bundledItem.type ~= module21.ItemType.Asset then
					continue
				end

				local id = tostring(bundledItem.id)
				local v7 = p2[id]
				v6[id] = module5.fromBundledItems(bundledItem, v7)
			end
		end

		return Cryo.Dictionary.join(p2, v6)
	end,
	[module6.name] = function(p2, data)
		module.isType(data.recommendedItems, "table", "recommendedItems must be a table.")

		local assetId = tostring(data.assetId)

		local v6 = {}
		local v7 = {}

		for k, recommendedItem in data.recommendedItems do
			local assetId2 = tostring(recommendedItem.item.assetId)

			local v8 = p2[assetId2]

			local v9 = module5.fromGetRecommendedItemsData(recommendedItem, data.assetTypeId, v8)

			local assetTypeId = data.assetTypeId
			v6[assetId2] = v9

			table.insert(v7, {
				id = assetId2,
				type = module21.ItemType.Asset,
				subType = assetTypeId
			})
		end

		local v8 = p2[assetId]
		v6[assetId] = module5.fromRecommendedItemSummaries(v7, v8)

		return Cryo.Dictionary.join(p2, v6)
	end,
	[module19.name] = function(p2, p3)
		module.isType(p3.assetResaleData, "table", "assetResaleData must be a table.")

		local assetId = tostring(p3.assetId)
		local v6 = p2[assetId]
		local v7 = module5.fromResaleData(p3.assetResaleData, v6)

		return Cryo.Dictionary.join(p2, { [assetId] = v7 })
	end,
	[module7.name] = function(p2, p3)
		module.isType(p3.assets, "table", "assets must be a table.")

		local v6 = {}

		for k, asset in p3.assets do
			local assetId = tostring(asset.assetId)
			local v7 = p2[assetId]
			v6[assetId] = module5.fromInventoryFetch(asset, v7)
		end

		return Cryo.Dictionary.join(p2, v6)
	end,
	[module8.name] = function(p2, p3)
		module.isType(p3.assets, "table", "assets must be a table.")

		local v6 = {}

		for k, asset in p3.assets do
			local id = tostring(asset.id)
			local v7 = p2[id]

			v6[id] = module5.fromOutfitDetails(asset, v7, p3.outfitModerationStatus)
		end

		return Cryo.Dictionary.join(p2, v6)
	end,
	[module9.name] = function(p2, p3)
		module.isType(p3.assets, "table", "assets must be a table.")

		local v6 = {}

		for k, asset in p3.assets do
			local id = tostring(asset.id)
			v6[id] = module5.fromInventoryOutfitDetails(asset, p2[id])
		end

		return Cryo.Dictionary.join(p2, v6)
	end,
	[module17.name] = function(p2, p3)
		module.isType(p3.assetId, "string", "assetId must be a sting.")
		module.isType(p3.userAssetIds, "table", "userAssetIds must be a table.")

		local assetId = tostring(p3.assetId)
		local v6 = p2[assetId]
		local v7 = module5.fromGetResellers(p3.userAssetIds, v6)
		return Cryo.Dictionary.join(p2, { [assetId] = v7 })
	end,
	[module16.name] = function(p2, p3)
		module.isType(p3.assetId, "string", "assetId must be a sting.")
		module.isType(p3.userAssetIds, "table", "userAssetIds must be a table.")

		local assetId = tostring(p3.assetId)

		local v6 = if p2[assetId] then p2[assetId] else module5.mock()
		local resellerUserAssetIds = v6.resellerUserAssetIds
		local v7

		if resellerUserAssetIds then
			v7 = Cryo.List.join(resellerUserAssetIds, p3.userAssetIds)
		else
			v7 = p3.userAssetIds
		end

		local v8 = module5.fromGetResellers(v7, v6)
		return Cryo.Dictionary.join(p2, { [assetId] = Cryo.Dictionary.join(v6, v8) })
	end,
	[module18.name] = function(p2, p3)
		module.isType(p3.assetId, "string", "assetId must be a sting.")
		module.isType(p3.priceInRobux, "number", "price must be a number.")

		local assetId = p3.assetId
		local priceInRobux = p3.priceInRobux
		local v6 = p2[assetId]
		local v7 = module5.fromLowestPrice(priceInRobux, v6)

		return Cryo.Dictionary.join(p2, { [assetId] = v7 })
	end,
	[module14.name] = function(p2, p3)
		module.isType(p3.assets, "table", "assets must be a table.")
		module.isType(p3.assetTypeId, "string", "assetTypeId must be a string.")

		local assetTypeId = p3.assetTypeId

		local v6 = {}

		for k, asset in p3.assets do
			local id = tostring(asset.id)
			local v7 = p2[id]

			v6[id] = module5.fromGetRecommendedItemsDataV2(asset, assetTypeId, v7)
		end

		return Cryo.Dictionary.join(p2, v6)
	end,
	[module15.name] = function(p2, p3)
		module.isType(p3.payload, "table", "payload must be a table.")

		if not p3.payload[widgetConstants.ContentType.Asset] then
			return p2
		end

		local values = {}

		for k, v6 in p3.payload[widgetConstants.ContentType.Asset] do
			local id = tostring(v6.id)
			local v7 = p2[id]
			local v8 = module5.fromHydrateWidgetInfo(v6, v7)
			values[id] = Cryo.Dictionary.join(v8, v8)
		end

		return Cryo.Dictionary.join(p2, values)
	end,
	[module22.name] = function(p2, p3)
		module.isType(p3.assetId, "string", "assetId must be a string.")
		module.isType(p3.isOwned, "boolean", "isOwned must be a bool.")

		local assetId = tostring(p3.assetId)
		local v6 = p2[assetId]
		local v7 = module5.fromIsOwned(p3.isOwned, v6)
		return Cryo.Dictionary.join(p2, { [assetId] = v7 })
	end,
	[module23.name] = function(p2, p3)
		if type(p3.assetId) ~= "string" or p3.assetId == "" or type(p3.isPlusExclusive) ~= "boolean" then
			return p2
		end

		local assetId = p3.assetId
		local v6 = p2[assetId]
		local v7 = module5.fromIsPlusExclusive(p3.isPlusExclusive, v6)
		return Cryo.Dictionary.join(p2, { [assetId] = v7 })
	end,
	[SetTryingOnInfo.name] = function(p2, p3)
		local assetTypeId = tostring(p3.assetTypeId)
		local assetId = tostring(p3.assetId)

		local joined = module5.fromAssetGrant(assetId, assetTypeId)
		local v6 = p2[assetId]

		if v6 and v6.assetType then
			return p2
		end

		if v6 then
			joined = Cryo.Dictionary.join(v6, joined)
		end

		return Cryo.Dictionary.join(p2, { [assetId] = joined })
	end,
	[module25.name] = function(p2, data)
		module.isType(data.assetId, "string", "assetId must be a string.")
		local assetId = tostring(data.assetId)
		local v6 = p2[assetId]

		local v7 = not (v6 and v6.updateCounter) and 1 or v6.updateCounter + 1

		local v8 = module5.fromModerationStatusUpdate(
			data.moderationStatus,
			v7,
			assetId,
			data.assetName,
			data.universeId,
			v6
		)

		return Cryo.Dictionary.join(p2, { [assetId] = v8 })
	end,
	[module29.name] = function(p2, p3)
		local assets = p3.avatarData.assets

		if assets == nil then
			return p2
		end

		local values = {}

		for k, asset in assets do
			local id = tostring(asset.id)
			local v6 = module5.fromReceivedAvatarData(asset)

			local v7 = p2[id]

			if v7 then
				if fFlagAXPopulateSupportsHeadShapesFromAvatarData then
					local v8 = v6.supportsHeadShapes == nil and {}
						or { supportsHeadShapes = v6.supportsHeadShapes }
					values[id] = Cryo.Dictionary.join(v6, v7, v8)
				else
					values[id] = Cryo.Dictionary.join(v6, v7)
				end
			else
				values[id] = v6
			end
		end

		return Cryo.Dictionary.join(p2, values)
	end,
	[module20.name] = function(p2, p3)
		module.isType(p3.assetVersionData, "table", "assetVersionData must be a table.")

		local assetId = tostring(p3.assetId)
		local v6 = p2[assetId]
		local v7 = module5.fromVersionData(p3.assetVersionData, v6)

		return Cryo.Dictionary.join(p2, { [assetId] = v7 })
	end,
	[module26.name] = module27.isEnabled() and function(p2, p3)
		local clone = table.clone(p2)

		for k, outfit in p3.outfits do
			local assetsToUpdate = outfit.assetsToUpdate
			local outfitModerationStatus = outfit.outfitModerationStatus

			if not assetsToUpdate then
				continue
			end

			for k2, v6 in assetsToUpdate do
				local id = tostring(v6.id)

				clone[id] = module5.fromOutfitDetails(v6, p2[id], outfitModerationStatus)
			end
		end

		return clone
	end or nil,
	[module28.name] = axRecentlyViewedSearchItemsIXPTest.isEnabled() and function(p2, p3)
		local clone = table.clone(p2)

		for k, v6 in p3.assetData or {} do
			local id = tostring(v6.id)
			local v7 = p2[id]
			clone[id] = module5.fromSortResults(v6, v7)
		end

		return clone
	end or nil,
	[purchaseItemsSuccess.name] = function(options, p2)
		local v6 = options or {}
		local values = {}

		for k, item in p2.items do
			if item.itemType ~= Enum.AvatarItemType.Asset.Name then
				continue
			end

			local itemId = tostring(item.itemId)
			local v7 = v6[itemId]

			if v7 then
				values[itemId] = Cryo.Dictionary.join(v7, { isOwned = true })
			end
		end

		return Cryo.Dictionary.join(v6, values)
	end,
	[fetchAssetOrBundleInfoBatchedSuccess.name] = function(options, p2)
		local joined = options or {}
		local hydratedAssets = p2.hydratedAssets
		local assetsInBundle = p2.assetsInBundle

		if #hydratedAssets > 0 then
			local v6 = {}

			for k, hydratedAsset in hydratedAssets do
				local id = tostring(hydratedAsset.id)
				local v7 = joined[id]
				v6[id] = module5.fromGetCatalogItemData(hydratedAsset, v7)
			end

			joined = Cryo.Dictionary.join(joined, v6)
		end

		if #assetsInBundle > 0 then
			local v6 = {}

			for k, v7 in assetsInBundle do
				local id = tostring(v7.id)
				local v8 = joined[id]
				v6[id] = module5.fromBundleItemData(v7, v8)
			end

			joined = Cryo.Dictionary.join(joined, v6)
		end

		return joined
	end,
	[module30.name] = function(items, p2)
		if fFlagAXSubscriptionRefetchEvictStores then
			if next(items) == nil then
				return items
			end

			return {}
		else
			local values = {}

			for k, item in items do
				if item.receivedCatalogData then
					values[k] = Cryo.Dictionary.join(item, {
						receivedCatalogData = false
					})
				end
			end

			if next(values) == nil then
				return items
			end

			return Cryo.Dictionary.join(items, values)
		end
	end
})
