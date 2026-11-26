local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local module4 = require("@luauforge/bundled/dPU")
local module5 = require("@luauforge/bundled/dPN")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local module6 = require("@luauforge/bundled/dVl")
local module7 = require("@luauforge/deferred/gTp")

local module8 = require("@luauforge/bundled/fCr")

local module9 = require("@luauforge/bundled/fCt")
local module10 = require("@luauforge/bundled/fCs")
local fetchAssetOrBundleInfoBatchedSuccess = AvatarExperienceCatalog.State.Actions.FetchAssetOrBundleInfoBatchedSuccess
require("@luauforge/bundled/AK")
require("@luauforge/bundled/dKT")

local fFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local fFlagAXPhotoboothMomentsFetchMissingDetails = AvatarExperienceFlags.FFlagAXPhotoboothMomentsFetchMissingDetails

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

	local localUserId = object:getState().LocalUserId
	table.insert(v5, object:dispatch(module9(p2, collectibleItemId, localUserId)))

	if hasResellers then
		table.insert(v5, object:dispatch(module8(p2, collectibleItemId, nil, module4.MaxResellersPerPage)))

		table.insert(v5, object:dispatch(module10(p2, collectibleItemId)))
	end

	return Promise.all(v5)
end

return function(p2, p3, items, p4, p5)
	return function(p6, p7)
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

		local v7
		v7 = fFlagAXPhotoboothMomentsFetchMissingDetails and p5 or module6.GetBatchItemDetailsKey(ids)

		return performFetch.Single(v7, function(object)
			local v8 = {}
			return GetExperienceSourceLanguage.FetchItemDetails(p2, v5):andThen(function(p8)
				local state = object:getState()

				v8 = not (p8.responseBody and p8.responseBody.data) and {} or p8.responseBody.data

				local v9 = {}
				local bundledItems = {}
				local v10 = {}

				for k, v11 in v8 do
					if fFlagAXInventoryDurablesExpiredFilter then
						local v12 = v6[v11.id]

						if v12 then
							v11.owned = v12.quantityOwned ~= nil and v12.quantityOwned > 0
							v11.isPurchasable = v12.isPurchasable
						end
					else
						v11.owned = v6[v11.id].quantityOwned > 0
						v11.isPurchasable = v6[v11.id].isPurchasable
					end

					if fFlagAXInventoryDurablesExpiredFilter and p4 then
						v11.skipReceivedCatalogData = true
					end

					if
						fFlagAXInventoryDurablesExpiredFilter
						and v11.assetType
						and type(v11.assetType) == "number"
					then
						v11.assetType = module5.AssetTypeIdStringToName[tostring(v11.assetType)]
					end

					local itemType = v11.itemType

					if itemType == module5.ItemType.Bundle then
						table.insert(v9, v11)

						if v11.bundledItems then
							for k2, bundledItem in v11.bundledItems do
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
						table.insert(v10, v11)
					end

					local collectibleItemId = v11.collectibleItemId
					local hasResellers = v11.hasResellers

					if collectibleItemId then
						fn(object, p2, collectibleItemId, hasResellers)
					end
				end

				local collectibleItemIds = {}

				for k, v11 in v8 do
					if v11.collectibleItemId then
						table.insert(collectibleItemIds, v11.collectibleItemId)
					end
				end

				object:dispatch(fetchAssetOrBundleInfoBatchedSuccess({
					hydratedBundles = v9,
					assetsInBundle = bundledItems,
					hydratedAssets = v10
				}))

				object:dispatch(module7(p2, collectibleItemIds))
			end)
		end)(p6)
	end
end
