local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Promise = require(parent.Promise)
local Signals = require(parent.Signals)

local SharedFlags = require(parent.SharedFlags)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
require(script.Parent.MarketplaceCatalogSortStoreTypes)

local FFlagMarketplaceCatalogSortTrackLastReceived = SharedFlags.FFlagMarketplaceCatalogSortTrackLastReceived
local FFlagAXSduiNilEmptyTagId = require(DataHydration.Flags.FFlagAXSduiNilEmptyTagId)
local FFlagDataHydrationAccountReset = SharedFlags.FFlagDataHydrationAccountReset

local function normalizeCardFooters(cardFooters)
	if not cardFooters then
		return nil
	end

	local result = table.create(#cardFooters)

	for _, item in cardFooters do
		table.insert(result, {
			contentType = item.contentType or item.content_type
		})
	end

	return result
end

local function normalizeCardStyle(cardStyle) -- 1 equivalent call inferred from this helper
	return {
		thumbnailAspectRatio = cardStyle.thumbnailAspectRatio or cardStyle.thumbnail_aspect_ratio
	}
end

local function normalizeSort(data) -- 1 equivalent call inferred from this helper
	if not (data.cardFooters or data.cardStyle) then
		return data
	end

	local clone = table.clone(data)

	if data.cardFooters then
		clone.cardFooters = normalizeCardFooters(data.cardFooters)
	end

	if data.cardStyle then
		clone.cardStyle = normalizeCardStyle(data.cardStyle) -- inferred equivalent call
	end

	return clone
end

local function clearEmptyTagId(p)
	if p.tagId ~= "" then
		return p
	end

	local clone = table.clone(p)
	clone.tagId = nil
	return clone
end

local function createMarketplaceCatalogSortStore()
	local cache

	if FFlagAXSduiNilEmptyTagId then
		cache = createDataCache(nil, nil, {
			sanitizeItem = clearEmptyTagId,
			observeLocalUser = not FFlagDataHydrationAccountReset and nil
		})
	else
		cache = createDataCache(nil, nil, FFlagDataHydrationAccountReset and {
			observeLocalUser = false
		} or nil)
	end

	local dataResolver = createDataResolver({
		cache = cache,
		fetchFn = function(_)
			return Promise.resolve({})
		end,
		keepCacheOnAccountReset = FFlagDataHydrationAccountReset and true or nil
	})
	local getLastReceivedSorts, v

	if FFlagMarketplaceCatalogSortTrackLastReceived then
		getLastReceivedSorts, v = Signals.createSignal({})
	else
		v = nil
	end

	local function updateMarketplaceCatalogSorts(p)
		v(p)
		cache.updateItems(p)
	end

	local function getNormalizedMarketplaceCatalogSort(p: string)
		local cachedItem = dataResolver.getCachedItem(p)
		return {
			data = function(p2)
				local data = cachedItem.data(p2)

				if not data then
					return nil
				end

				return normalizeSort(data) -- inferred equivalent call
			end,
			status = cachedItem.status
		}
	end

	local function clear()
		if v then
			v({})
		end

		dataResolver.clear()
	end

	local marketplaceCatalogSortStore = {
		getMarketplaceCatalogSort = dataResolver.getCachedItem,
		getMarketplaceCatalogSorts = dataResolver.getCachedItems,
		getNormalizedMarketplaceCatalogSort = getNormalizedMarketplaceCatalogSort,
		updateMarketplaceCatalogSorts = 0,
		updateMarketplaceCatalogSort = 0,
		getLastReceivedSorts = 0,
		clear = 0,
		dispose = 0
	}

	if not FFlagMarketplaceCatalogSortTrackLastReceived then
		updateMarketplaceCatalogSorts = cache.updateItems
	end

	marketplaceCatalogSortStore.updateMarketplaceCatalogSorts = updateMarketplaceCatalogSorts

	marketplaceCatalogSortStore.updateMarketplaceCatalogSort = cache.updateItem
	marketplaceCatalogSortStore.getLastReceivedSorts = getLastReceivedSorts

	if not FFlagMarketplaceCatalogSortTrackLastReceived then
		clear = dataResolver.clear
	end

	marketplaceCatalogSortStore.clear = clear
	marketplaceCatalogSortStore.dispose = dataResolver.dispose
	return marketplaceCatalogSortStore
end

return createMarketplaceCatalogSortStore
