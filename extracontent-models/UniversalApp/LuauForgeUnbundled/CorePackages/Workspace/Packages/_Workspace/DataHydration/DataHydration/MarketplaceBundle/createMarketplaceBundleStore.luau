local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceBundle/MarketplaceBundleStoreTypes")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")

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

local function normalizeBundledItems(bundledItems)
	if not bundledItems then
		return nil
	end

	local result = table.create(#bundledItems)

	for k, item in bundledItems do
		local v5 = { id = item.id, assetType = 0, type = 0 }
		local v6 = if item.assetType == nil then item.asset_type else item.assetType
		v5.assetType = v6
		v5.type = item.type
		table.insert(result, v5)
	end

	return result
end

local function normalizeBundle(p2)
	if not (p2.taxonomy or p2.bundledItems) then
		return p2
	end

	local clone = table.clone(p2)

	if p2.taxonomy then
		clone.taxonomy = normalizeTaxonomy(p2.taxonomy)
	end

	if p2.bundledItems then
		clone.bundledItems = normalizeBundledItems(p2.bundledItems)
	end

	return clone
end

local function createMarketplaceBundleStore()
	local v5 = createDataCache()
	local v6 = createDataResolver({
		cache = v5,
		fetchFn = function(p2)
			return Promise.resolve({})
		end
	})

	return {
		getMarketplaceBundleInfo = v6.getCachedItem,
		getMarketplaceBundleInfos = v6.getCachedItems,
		getNormalizedMarketplaceBundleInfo = function(p2)
			local cachedItem = v6.getCachedItem(p2)
			return {
				data = function(p3)
					local data = cachedItem.data(p3)

					if not data then
						return nil
					end

					if not (data.taxonomy or data.bundledItems) then
						return data
					end

					local clone = table.clone(data)

					if data.taxonomy then
						clone.taxonomy = normalizeTaxonomy(data.taxonomy)
					end

					if data.bundledItems then
						clone.bundledItems = normalizeBundledItems(data.bundledItems)
					end

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
		updateMarketplaceBundleInfo = v5.updateItem,
		updateMarketplaceBundleInfos = v5.updateItems,
		clear = v5.clear,
		dispose = v5.dispose
	}
end

return createMarketplaceBundleStore
