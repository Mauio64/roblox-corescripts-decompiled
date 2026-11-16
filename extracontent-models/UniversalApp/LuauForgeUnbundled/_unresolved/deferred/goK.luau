local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local module4 = require("@luauforge/bundled/dME")
local module5 = require("@luauforge/bundled/dMx")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module6 = require("@luauforge/bundled/dRQ")
local module7 = require("@luauforge/deferred/goL")

local module8 = require("@luauforge/bundled/fuQ")

local module9 = require("@luauforge/bundled/fuS")
local module10 = require("@luauforge/bundled/fuR")
local fetchAssetOrBundleInfoBatchedSuccess = AvatarExperienceCatalog.State.Actions.FetchAssetOrBundleInfoBatchedSuccess
require("@luauforge/bundled/AH")
require("@luauforge/bundled/dHK")

local fFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter

local function keyMapper(p2)
	return module6.GetBatchItemDetailsKey(p2)
end

local function checkIfReceivedFromBundleItemData(p2, p3): boolean
	local assetInfo = p2.AvatarExperience.Common.AssetInfos[p3]

	if assetInfo and assetInfo.receivedFromBundleItemData then
		return true
	end

	return false
end

local function fn(object, p2, collectibleItemId, hasResellers)
	local v5 = {}

	table.insert(v5, object:dispatch(module9(p2, collectibleItemId, object:getState().LocalUserId)))

	if hasResellers then
		table.insert(v5, object:dispatch(module8(p2, collectibleItemId, nil, module4.MaxResellersPerPage)))

		table.insert(v5, object:dispatch(module10(p2, collectibleItemId)))
	end

	return Promise.all(v5)
end

return function(p2, p3, items, p4)
	return function(p5, p6)
		local ids = {}

		local v5 = {}

		local v6 = {}

		for k, item in items do
			table.insert(ids, item.id)
			local id = tonumber(item.id)

			if not id then
				continue
			end

			table.insert(v5, { id = id, itemType = item.itemType })
			v6[id] = item
		end

		return performFetch.Single(module6.GetBatchItemDetailsKey(ids), function(object)
			local v7 = {}
			return GetExperienceSourceLanguage.FetchItemDetails(p2, v5):andThen(function(p7)
				local state = object:getState()

				v7 = not (p7.responseBody and p7.responseBody.data) and {} or p7.responseBody.data

				local v8 = {}
				local bundledItems = {}
				local v9 = {}

				for k, v10 in v7 do
					if fFlagAXInventoryDurablesExpiredFilter then
						local v11 = v6[v10.id]

						if v11 then
							v10.owned = v11.quantityOwned ~= nil and v11.quantityOwned > 0
							v10.isPurchasable = v11.isPurchasable
						end
					else
						v10.owned = v6[v10.id].quantityOwned > 0
						v10.isPurchasable = v6[v10.id].isPurchasable
					end

					if fFlagAXInventoryDurablesExpiredFilter and p4 then
						v10.skipReceivedCatalogData = true
					end

					if
						fFlagAXInventoryDurablesExpiredFilter
						and v10.assetType
						and type(v10.assetType) == "number"
					then
						v10.assetType = module5.AssetTypeIdStringToName[tostring(v10.assetType)]
					end

					local itemType = v10.itemType

					if itemType == module5.ItemType.Bundle then
						table.insert(v8, v10)

						if v10.bundledItems then
							for k2, bundledItem in v10.bundledItems do
								local id = tostring(bundledItem.id)

								if bundledItem.Type ~= module5.ItemType.Asset then
									continue
								end

								local assetInfo = state.AvatarExperience.Common.AssetInfos[id]

								if not (assetInfo and assetInfo.receivedFromBundleItemData) then
									table.insert(bundledItems, bundledItem)
								end
							end
						end
					elseif itemType == module5.ItemType.Asset then
						table.insert(v9, v10)
					end

					local collectibleItemId = v10.collectibleItemId
					local hasResellers = v10.hasResellers

					if collectibleItemId then
						fn(object, p2, collectibleItemId, hasResellers)
					end
				end

				local collectibleItemIds = {}

				for k, v10 in v7 do
					if v10.collectibleItemId then
						table.insert(collectibleItemIds, v10.collectibleItemId)
					end
				end

				object:dispatch(fetchAssetOrBundleInfoBatchedSuccess({
					hydratedBundles = v8,
					assetsInBundle = bundledItems,
					hydratedAssets = v9
				}))

				object:dispatch(module7(p2, collectibleItemIds))
			end)
		end)(p5)
	end
end
