local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceAsset/MarketplaceAssetStoreTypes")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")

local FFlagMarketplaceAssetStoreKeepOnAccountReset = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Flags/FFlagMarketplaceAssetStoreKeepOnAccountReset")

local function normalizeTaxonomy(taxonomy)
	if not taxonomy then
		return nil
	end

	local result = table.create(#taxonomy)

	for k, item in taxonomy do
		local v6 = if item.taxonomyId == nil then item.taxonomy_id else item.taxonomyId
		local v7 = if item.taxonomyName == nil then item.taxonomy_name else item.taxonomyName
		table.insert(result, { taxonomyId = v6, taxonomyName = v7 })
	end

	return result
end

local function normalizeAsset(p2)
	if not p2.taxonomy then
		return p2
	end

	local clone = table.clone(p2)
	clone.taxonomy = normalizeTaxonomy(p2.taxonomy)
	return clone
end

local function createMarketplaceAssetStore()
	local v5 = createDataCache(nil, nil, FFlagMarketplaceAssetStoreKeepOnAccountReset and { observeLocalUser = false } or nil)

	local v6 = createDataResolver({
		cache = v5,
		fetchFn = function(p2)
			return Promise.resolve({})
		end,
		keepCacheOnAccountReset = FFlagMarketplaceAssetStoreKeepOnAccountReset and true or nil
	})

	return {
		getMarketplaceAssetInfo = v6.getCachedItem,
		getMarketplaceAssetInfos = v6.getCachedItems,
		getNormalizedMarketplaceAssetInfo = function(p2)
			local cachedItem = v6.getCachedItem(p2)
			return {
				data = function(p3)
					local data = cachedItem.data(p3)

					if not data then
						return nil
					end

					if not data.taxonomy then
						return data
					end

					local clone = table.clone(data)
					clone.taxonomy = normalizeTaxonomy(data.taxonomy)
					return clone
				end,
				status = cachedItem.status
			}
		end,
		getCreatingUniverseId = function(p2)
			local data = v6.getCachedItem(p2).data
			return function(p3)
				local v7 = data(p3)

				local creatingUniverseId = if v7 then v7.creatingUniverseId else nil

				if typeof(creatingUniverseId) == "number" then
					return (tostring(creatingUniverseId))
				end

				if typeof(creatingUniverseId) == "string" and creatingUniverseId ~= "" then
					return creatingUniverseId
				end

				return nil
			end
		end,
		updateMarketplaceAssetInfo = v5.updateItem,
		updateMarketplaceAssetInfos = v5.updateItems,
		clear = v5.clear,
		dispose = v5.dispose
	}
end

return createMarketplaceAssetStore
