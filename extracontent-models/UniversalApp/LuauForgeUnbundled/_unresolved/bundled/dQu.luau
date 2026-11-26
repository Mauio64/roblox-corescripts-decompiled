local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")
local Cryo = require(CorePackages.Packages.Cryo)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
require("@luauforge/bundled/dKU")

local module5 = require("@luauforge/bundled/dQv")
local module6 = require("@luauforge/bundled/dPN")

local module7 = require("@luauforge/bundled/dQw")

local module8 = require("@luauforge/bundled/dQx")
local module9 = require("@luauforge/bundled/dQd")

local SetBundles = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Actions/SetBundles")
local module11 = require("@luauforge/bundled/dQf")
local module12 = require("@luauforge/bundled/dQz")
local purchaseItemsSuccess = AvatarExperienceCatalog.State.Actions.PurchaseItemsSuccess
local fetchAssetOrBundleInfoBatchedSuccess = AvatarExperienceCatalog.State.Actions.FetchAssetOrBundleInfoBatchedSuccess
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
require("@luauforge/bundled/dPs")

local module13 = require("@luauforge/bundled/dQr")
local axRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local module14 = require("@luauforge/bundled/dQt")
local fFlagAXSubscriptionRefetchEvictStores = AvatarExperienceFlags.FFlagAXSubscriptionRefetchEvictStores

return Rodux.createReducer({}, {
	[module8.name] = function(p2, p3)
		module.isType(p3.bundleId, "string", "bundleId must be a string.")
		module.isType(p3.bundleData, "table", "bundleData must be a table.")

		local bundleId = tostring(p3.bundleId)
		local v6 = p2[bundleId]
		local v7 = module5.fromGetCatalogItemData(p3.bundleData, v6)
		return Cryo.Dictionary.join(p2, { [bundleId] = v7 })
	end,
	[SetBundles.name] = function(p2, p3)
		module.isType(p3.bundles, "table", "bundles must be a table.")

		local v6 = {}

		for k, bundle in p3.bundles do
			local id = tostring(bundle.id)
			local v7 = p2[id]
			v6[id] = module5.fromGetRecommendedItemsDataV2(bundle, v7)
		end

		return Cryo.Dictionary.join(p2, v6)
	end,
	[module11.name] = function(p2, p3)
		module.isType(p3.payload, "table", "payload must be a table.")

		if not p3.payload[widgetConstants.ContentType.Bundle] then
			return p2
		end

		local v6 = {}

		for k, v7 in p3.payload[widgetConstants.ContentType.Bundle] do
			local id = tostring(v7.id)
			local v8 = p2[id]
			v6[id] = module5.fromHydrateWidgetInfo(v7, v8)
		end

		return Cryo.Dictionary.join(p2, v6)
	end,
	[module9.name] = function(p2, p3)
		module.isType(p3.sortResults, "table", "sortResults must be a table.")

		local v6 = {}

		for k, sortResult in p3.sortResults do
			local id = tostring(sortResult.id)
			local v7 = p2[id]
			v6[id] = module5.fromSortResults(sortResult, v7)
		end

		return Cryo.Dictionary.join(p2, v6)
	end,
	[module7.name] = function(p2, p3)
		module.isType(p3.bundleId, "string", "bundleId must be a string.")
		module.isType(p3.recommendedItems, "table", "recommendedItems must be a table.")

		local bundleId = tostring(p3.bundleId)

		local v6 = {}
		local v7 = {}

		for k, recommendedItem in p3.recommendedItems do
			local id = tostring(recommendedItem.id)

			local v8 = p2[id]
			v6[id] = module5.fromGetRecommendedItemsDataV2(recommendedItem, v8)

			v7[#v7 + 1] = {
				id = id,
				type = module6.ItemType.Bundle,
				subType = tostring(recommendedItem.bundleType)
			}
		end

		local v8 = p2[bundleId]
		v6[bundleId] = module5.fromRecommendedItemSummaries(v7, v8)

		return Cryo.Dictionary.join(p2, v6)
	end,
	[module12.name] = function(p2, p3)
		module.isType(p3.bundleId, "string", "bundleId must be a string.")
		module.isType(p3.isOwned, "boolean", "isOwned must be a bool.")

		local bundleId = tostring(p3.bundleId)
		local v6 = p2[bundleId]
		local v7 = module5.fromIsOwned(p3.isOwned, v6)
		return Cryo.Dictionary.join(p2, { [bundleId] = v7 })
	end,
	[module13.name] = axRecentlyViewedSearchItemsIXPTest.isEnabled() and function(p2, p3)
		local clone = table.clone(p2)

		for k, v6 in p3.bundleData or {} do
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
			if item.itemType ~= Enum.AvatarItemType.Bundle.Name then
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
		local v6 = options or {}

		local v7 = {}

		for k, hydratedBundle in p2.hydratedBundles do
			local id = tostring(hydratedBundle.id)
			local v8 = v6[id]
			v7[id] = module5.fromGetCatalogItemData(hydratedBundle, v8)
		end

		return Cryo.Dictionary.join(v6, v7)
	end,
	[module14.name] = function(items, p2)
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
