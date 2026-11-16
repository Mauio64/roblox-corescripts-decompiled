local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent
local Promise = require(parent.Promise)
require(parent.Signals)

local createDataCache = require(DataHydration.createDataCache)
require(DataHydration.DataHydrationTypes)
require(script.Parent.MarketplaceBundleStoreTypes)
local createDataResolver = require(DataHydration.createDataResolver)

local function normalizeTaxonomy(taxonomy)
	if not taxonomy then
		return nil
	end

	local result = table.create(#taxonomy)

	for _, item in taxonomy do
		local taxonomyId

		if item.taxonomyId == nil then
			taxonomyId = item.taxonomy_id
		else
			taxonomyId = item.taxonomyId
		end

		local taxonomyName

		if item.taxonomyName == nil then
			taxonomyName = item.taxonomy_name
		else
			taxonomyName = item.taxonomyName
		end

		table.insert(result, { taxonomyId = taxonomyId, taxonomyName = taxonomyName })
	end

	return result
end

local function normalizeBundledItems(bundledItems)
	if not bundledItems then
		return nil
	end

	local result = table.create(#bundledItems)

	for _, item in bundledItems do
		local v = { id = item.id, assetType = 0, type = 0 }
		local assetType

		if item.assetType == nil then
			assetType = item.asset_type
		else
			assetType = item.assetType
		end

		v.assetType = assetType
		v.type = item.type
		table.insert(result, v)
	end

	return result
end

local function normalizeBundle(data) -- 1 equivalent call inferred from this helper
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
end

local function createMarketplaceBundleStore()
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		fetchFn = function(_)
			return Promise.resolve({})
		end
	})

	return {
		getMarketplaceBundleInfo = dataResolver.getCachedItem,
		getMarketplaceBundleInfos = dataResolver.getCachedItems,
		getNormalizedMarketplaceBundleInfo = function(p: string)
			local cachedItem = dataResolver.getCachedItem(p)
			return {
				data = function(p2)
					local data = cachedItem.data(p2)

					if not data then
						return nil
					end

					return normalizeBundle(data) -- inferred equivalent call
				end,
				status = cachedItem.status
			}
		end,
		getCreatingUniverseId = function(p: string)
			local data = dataResolver.getCachedItem(p).data
			return function(p2)
				local v = data(p2)
				local creatingUniverseId

				if v then
					creatingUniverseId = v.creatingUniverseId
				end

				if typeof(creatingUniverseId) == "number" then
					return (tostring(creatingUniverseId))
				end

				if typeof(creatingUniverseId) == "string" and creatingUniverseId ~= "" then
					return creatingUniverseId
				end

				return nil
			end
		end,
		updateMarketplaceBundleInfo = dataCache.updateItem,
		updateMarketplaceBundleInfos = dataCache.updateItems,
		clear = dataCache.clear,
		dispose = dataCache.dispose
	}
end

return createMarketplaceBundleStore
