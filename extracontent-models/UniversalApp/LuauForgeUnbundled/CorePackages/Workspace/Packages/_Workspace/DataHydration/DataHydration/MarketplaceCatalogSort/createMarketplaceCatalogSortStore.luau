local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceCatalogSort/MarketplaceCatalogSortStoreTypes")

local fFlagMarketplaceCatalogSortTrackLastReceived = SharedFlags.FFlagMarketplaceCatalogSortTrackLastReceived
local FFlagAXSduiNilEmptyTagId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Flags/FFlagAXSduiNilEmptyTagId")
local fFlagDataHydrationAccountReset = SharedFlags.FFlagDataHydrationAccountReset

local function normalizeCardFooters(cardFooters)
	if not cardFooters then
		return nil
	end

	local result = table.create(#cardFooters)

	for k, item in cardFooters do
		table.insert(result, {
			contentType = item.contentType or item.content_type
		})
	end

	return result
end

local function normalizeCardStyle(p2)
	return {
		thumbnailAspectRatio = p2.thumbnailAspectRatio or p2.thumbnail_aspect_ratio
	}
end

local function normalizeSort(p2)
	if not (p2.cardFooters or p2.cardStyle) then
		return p2
	end

	local clone = table.clone(p2)

	if p2.cardFooters then
		clone.cardFooters = normalizeCardFooters(p2.cardFooters)
	end

	if p2.cardStyle then
		local cardStyle = p2.cardStyle
		clone.cardStyle = {
			thumbnailAspectRatio = cardStyle.thumbnailAspectRatio or cardStyle.thumbnail_aspect_ratio
		}
	end

	return clone
end

local function clearEmptyTagId(p2)
	if p2.tagId ~= "" then
		return p2
	end

	local clone = table.clone(p2)
	clone.tagId = nil
	return clone
end

local function createMarketplaceCatalogSortStore()
	local v5

	if FFlagAXSduiNilEmptyTagId then
		v5 = createDataCache(nil, nil, {
			sanitizeItem = clearEmptyTagId,
			observeLocalUser = if fFlagDataHydrationAccountReset then false else nil
		})
	else
		v5 = createDataCache(nil, nil, fFlagDataHydrationAccountReset and {
			observeLocalUser = false
		} or nil)
	end

	local v6 = createDataResolver({
		cache = v5,
		fetchFn = function(p2)
			return Promise.resolve({})
		end,
		keepCacheOnAccountReset = fFlagDataHydrationAccountReset and true or nil
	})
	local v7, v8

	if fFlagMarketplaceCatalogSortTrackLastReceived then
		v7, v8 = Signals.createSignal({})
	else
		v8 = nil
	end

	local function updateMarketplaceCatalogSorts(p2)
		v8(p2)
		v5.updateItems(p2)
	end

	local function getNormalizedMarketplaceCatalogSort(p2)
		local cachedItem = v6.getCachedItem(p2)
		return {
			data = function(p3)
				local data = cachedItem.data(p3)

				if not data then
					return nil
				end

				if not (data.cardFooters or data.cardStyle) then
					return data
				end

				local clone = table.clone(data)

				if data.cardFooters then
					clone.cardFooters = normalizeCardFooters(data.cardFooters)
				end

				if data.cardStyle then
					local cardStyle = data.cardStyle
					clone.cardStyle = {
						thumbnailAspectRatio = cardStyle.thumbnailAspectRatio or cardStyle.thumbnail_aspect_ratio
					}
				end

				return clone
			end,
			status = cachedItem.status
		}
	end

	local function clear()
		if v8 then
			v8({})
		end

		v6.clear()
	end

	local marketplaceCatalogSortStore = {
		getMarketplaceCatalogSort = v6.getCachedItem,
		getMarketplaceCatalogSorts = v6.getCachedItems,
		getNormalizedMarketplaceCatalogSort = getNormalizedMarketplaceCatalogSort,
		updateMarketplaceCatalogSorts = 0,
		updateMarketplaceCatalogSort = 0,
		getLastReceivedSorts = 0,
		clear = 0,
		dispose = 0
	}

	if not fFlagMarketplaceCatalogSortTrackLastReceived then
		updateMarketplaceCatalogSorts = v5.updateItems
	end

	marketplaceCatalogSortStore.updateMarketplaceCatalogSorts = updateMarketplaceCatalogSorts

	marketplaceCatalogSortStore.updateMarketplaceCatalogSort = v5.updateItem
	marketplaceCatalogSortStore.getLastReceivedSorts = v7

	if not fFlagMarketplaceCatalogSortTrackLastReceived then
		clear = v6.clear
	end

	marketplaceCatalogSortStore.clear = clear
	marketplaceCatalogSortStore.dispose = v6.dispose
	return marketplaceCatalogSortStore
end

return createMarketplaceCatalogSortStore
