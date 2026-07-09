local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Promise = require(CorePackages.Packages.Promise)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local WebApi = require(Modules.AvatarExperience.Catalog.Http.WebApi)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local FetchCollectibleItemDataBatched = require(Modules.AvatarExperience.Catalog.Thunks.FetchCollectibleItemDataBatched)
local FetchCollectibResellersInstances = require(Modules.AvatarExperience.Catalog.Thunks.FetchCollectibResellersInstances)
local FetchCollectibleResellableInstances = require(Modules.AvatarExperience.Catalog.Thunks.FetchCollectibleResellableInstances)
local FetchCollectibleResaleData = require(Modules.AvatarExperience.Catalog.Thunks.FetchCollectibleResaleData)
local FetchAssetOrBundleInfoBatchedSuccess = AvatarExperienceCatalog.State.Actions.FetchAssetOrBundleInfoBatchedSuccess

require(Modules.LuaApp.Types.RoduxTypes)
require(Modules.AvatarExperience.Common.AvatarExperienceState)

local FFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter

local function keyMapper(p1) -- line: 29
	-- upvalues: CatalogUtils (copy)
	return CatalogUtils.GetBatchItemDetailsKey(p1)
end
local function checkIfReceivedFromBundleItemData(p2, p3) -- line: 33
	local v23 = p2.AvatarExperience.Common.AssetInfos[p3]

	if v23 and v23.receivedFromBundleItemData then
		return true
	end

	return false
end
local function v19(p4, p5, p6, p7) -- line: 41
	-- upvalues: FetchCollectibleResellableInstances (copy), FetchCollectibResellersInstances (copy), CatalogConstants (copy), FetchCollectibleResaleData (copy), Promise (copy)
	local t1 = {}
	local LocalUserId = p4:getState().LocalUserId

	table.insert(t1, p4:dispatch(FetchCollectibleResellableInstances(p5, p6, LocalUserId)))

	if p7 then
		table.insert(t1, p4:dispatch(FetchCollectibResellersInstances(p5, p6, nil, CatalogConstants.MaxResellersPerPage)))
		table.insert(t1, p4:dispatch(FetchCollectibleResaleData(p5, p6)))
	end

	return Promise.all(t1)
end

return function(p8: ((...any) -> ...any), _, p10, b1: boolean?) -- line: 68
	-- upvalues: PerformFetch (copy), CatalogUtils (copy), WebApi (copy), FFlagAXInventoryDurablesExpiredFilter (copy), Constants (copy), v19 (copy), FetchAssetOrBundleInfoBatchedSuccess (copy), FetchCollectibleItemDataBatched (copy)
	return function(p11, _) -- line: 69
		-- upvalues: p10 (copy), PerformFetch (copy), CatalogUtils (copy), WebApi (copy), p8 (copy), FFlagAXInventoryDurablesExpiredFilter (copy), b1 (copy), Constants (copy), v19 (copy), FetchAssetOrBundleInfoBatchedSuccess (copy), FetchCollectibleItemDataBatched (copy)
		local t2 = {}
		local t3 = {}
		local t4 = {}

		for _, v40 in p10 do
			table.insert(t2, v40.id)

			local num = tonumber(v40.id)

			if num then
				table.insert(t3, {
					id = num,
					itemType = v40.itemType
				})
				t4[num] = v40
			end
		end

		return PerformFetch.Single(CatalogUtils.GetBatchItemDetailsKey(t2), function(p13) -- line: 87
			-- upvalues: WebApi (copy), p8 (copy), t3 (copy), FFlagAXInventoryDurablesExpiredFilter (copy), t4 (copy), b1 (copy), Constants (copy), v19 (copy), FetchAssetOrBundleInfoBatchedSuccess (copy), FetchCollectibleItemDataBatched (copy)
			local t5 = {}

			return WebApi.FetchItemDetails(p8, t3):andThen(function(p14) -- line: 89
				-- upvalues: p13 (copy), t5 (ref), FFlagAXInventoryDurablesExpiredFilter (copy), t4 (copy), b1 (copy), Constants (copy), v19 (copy), p8 (copy), FetchAssetOrBundleInfoBatchedSuccess (copy), FetchCollectibleItemDataBatched (copy)
				local v45 = p13:getState()

				t5 = if not p14.responseBody or not p14.responseBody.data then {} else p14.responseBody.data

				local t6 = {}
				local t7 = {}
				local t8 = {}

				for _, v50 in t5 do
					if FFlagAXInventoryDurablesExpiredFilter then
						local v51 = t4[v50.id]

						if v51 then
							v50.owned = v51.quantityOwned ~= nil and v51.quantityOwned > 0
							v50.isPurchasable = v51.isPurchasable
						end
					else
						v50.owned = t4[v50.id].quantityOwned > 0
						v50.isPurchasable = t4[v50.id].isPurchasable
					end

					if FFlagAXInventoryDurablesExpiredFilter and b1 then
						v50.skipReceivedCatalogData = true
					end

					if FFlagAXInventoryDurablesExpiredFilter and v50.assetType and type(v50.assetType) == "number" then
						v50.assetType = Constants.AssetTypeIdStringToName[tostring(v50.assetType)]
					end

					local itemType = v50.itemType

					if itemType == Constants.ItemType.Bundle then
						table.insert(t6, v50)

						if v50.bundledItems then
							for _, v54 in v50.bundledItems do
								local str = tostring(v54.id)

								if v54.Type == Constants.ItemType.Asset then
									local v56 = v45.AvatarExperience.Common.AssetInfos[str]

									if not v56 or not v56.receivedFromBundleItemData then
										table.insert(t7, v54)
									end
								end
							end
						end
					elseif itemType == Constants.ItemType.Asset then
						table.insert(t8, v50)
					end

					local collectibleItemId = v50.collectibleItemId
					local hasResellers = v50.hasResellers

					if collectibleItemId then
						v19(p13, p8, collectibleItemId, hasResellers)
					end
				end

				local t9 = {}

				for _, v61 in t5 do
					if v61.collectibleItemId then
						table.insert(t9, v61.collectibleItemId)
					end
				end

				p13:dispatch(FetchAssetOrBundleInfoBatchedSuccess({
					hydratedBundles = t6,
					assetsInBundle = t7,
					hydratedAssets = t8
				}))
				p13:dispatch(FetchCollectibleItemDataBatched(p8, t9))
			end)
		end)(p11)
	end
end
