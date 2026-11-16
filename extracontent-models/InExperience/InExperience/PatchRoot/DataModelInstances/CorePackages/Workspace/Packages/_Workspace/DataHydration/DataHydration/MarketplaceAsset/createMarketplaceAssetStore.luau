local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent
local Promise = require(parent.Promise)
require(parent.Signals)

local createDataCache = require(DataHydration.createDataCache)
require(DataHydration.DataHydrationTypes)
require(script.Parent.MarketplaceAssetStoreTypes)
local createDataResolver = require(DataHydration.createDataResolver)

local FFlagMarketplaceAssetStoreKeepOnAccountReset = require(DataHydration.Flags.FFlagMarketplaceAssetStoreKeepOnAccountReset)

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

local function normalizeAsset(data) -- 1 equivalent call inferred from this helper
	if not data.taxonomy then
		return data
	end

	local clone = table.clone(data)
	clone.taxonomy = normalizeTaxonomy(data.taxonomy)
	return clone
end

local function createMarketplaceAssetStore()
	local dataCache = createDataCache(
		nil,
		nil,
		FFlagMarketplaceAssetStoreKeepOnAccountReset and { observeLocalUser = false } or nil
	)

	local dataResolver = createDataResolver({
		cache = dataCache,
		fetchFn = function(_)
			return Promise.resolve({})
		end,
		keepCacheOnAccountReset = FFlagMarketplaceAssetStoreKeepOnAccountReset and true or nil
	})

	return {
		getMarketplaceAssetInfo = dataResolver.getCachedItem,
		getMarketplaceAssetInfos = dataResolver.getCachedItems,
		getNormalizedMarketplaceAssetInfo = function(p: string)
			local cachedItem = dataResolver.getCachedItem(p)
			return {
				data = function(p2)
					local data = cachedItem.data(p2)

					if not data then
						return nil
					end

					return normalizeAsset(data) -- inferred equivalent call
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
		updateMarketplaceAssetInfo = dataCache.updateItem,
		updateMarketplaceAssetInfos = dataCache.updateItems,
		clear = dataCache.clear,
		dispose = dataCache.dispose
	}
end

return createMarketplaceAssetStore
