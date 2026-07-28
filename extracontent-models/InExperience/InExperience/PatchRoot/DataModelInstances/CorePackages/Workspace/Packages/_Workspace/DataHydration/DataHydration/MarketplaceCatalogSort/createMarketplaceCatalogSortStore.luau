local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Promise = require(DataHydrationParent.Promise)
local Signals = require(DataHydrationParent.Signals)
local SharedFlags = require(DataHydrationParent.SharedFlags)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)
require(script.Parent.MarketplaceCatalogSortStoreTypes)

local FFlagMarketplaceCatalogSortTrackLastReceived = SharedFlags.FFlagMarketplaceCatalogSortTrackLastReceived

local function normalizeCardFooters(t1: {[any]: any}?) -- line: 34
	if not t1 then
		return nil
	end

	local t2 = table.create(#t1)

	for _, v16 in t1 do
		table.insert(t2, {
			contentType = v16.contentType or v16.content_type
		})
	end

	return t2
end
local function normalizeCardStyle(p1) -- line: 47
	return {
		thumbnailAspectRatio = p1.thumbnailAspectRatio or p1.thumbnail_aspect_ratio
	}
end
local function normalizeSort(p2) -- line: 53
	-- upvalues: normalizeCardFooters (copy)
	if not p2.cardFooters and not p2.cardStyle then
		return p2
	end

	local v19 = table.clone(p2)

	if p2.cardFooters then
		v19.cardFooters = normalizeCardFooters(p2.cardFooters)
	end

	if p2.cardStyle then
		local cardStyle = p2.cardStyle

		v19.cardStyle = {
			thumbnailAspectRatio = cardStyle.thumbnailAspectRatio or cardStyle.thumbnail_aspect_ratio
		}
	end

	return v19
end
local function createMarketplaceCatalogSortStore() -- line: 67
	-- upvalues: createDataCache (copy), createDataResolver (copy), Promise (copy), FFlagMarketplaceCatalogSortTrackLastReceived (copy), Signals (copy), normalizeCardFooters (copy)
	local v21 = createDataCache()
	local v22 = createDataResolver({
		cache = v21,
		fetchFn = function(_: {[any]: any}) -- line: 71
			-- upvalues: Promise (copy)
			return Promise.resolve({})
		end
	})
	local v23 = nil
	local u24 = nil

	if FFlagMarketplaceCatalogSortTrackLastReceived then
		local v25

		v23, v25 = Signals.createSignal({})
		u24 = v25
	end

	local function updateMarketplaceCatalogSorts(t4: {[any]: any}) -- line: 88
		-- upvalues: u24 (ref), v21 (copy)
		u24(t4)
		v21.updateItems(t4)
	end
	local function clear() -- line: 112
		-- upvalues: u24 (ref), v22 (copy)
		if u24 then
			u24({})
		end

		v22.clear()
	end

	return {
		getMarketplaceCatalogSort = v22.getCachedItem,
		getMarketplaceCatalogSorts = v22.getCachedItems,
		getNormalizedMarketplaceCatalogSort = function(s1: string) -- line: 96
			-- upvalues: v22 (copy), normalizeCardFooters (copy)
			local v31 = v22.getCachedItem(s1)

			return {
				data = function(p3) -- line: 99
					-- upvalues: v31 (copy), normalizeCardFooters (copy)
					local v33 = v31.data(p3)

					if v33 then
						if not v33.cardFooters and not v33.cardStyle then
							return v33
						end

						local v34 = table.clone(v33)

						if v33.cardFooters then
							v34.cardFooters = normalizeCardFooters(v33.cardFooters)
						end

						if v33.cardStyle then
							local cardStyle = v33.cardStyle

							v34.cardStyle = {
								thumbnailAspectRatio = cardStyle.thumbnailAspectRatio or cardStyle.thumbnail_aspect_ratio
							}
						end

						return v34
					end

					return nil
				end,
				status = v31.status
			}
		end,
		updateMarketplaceCatalogSorts = if not FFlagMarketplaceCatalogSortTrackLastReceived then v21.updateItems else updateMarketplaceCatalogSorts,
		updateMarketplaceCatalogSort = v21.updateItem,
		getLastReceivedSorts = v23,
		clear = if not FFlagMarketplaceCatalogSortTrackLastReceived then v22.clear else clear,
		dispose = v22.dispose
	}
end

return createMarketplaceCatalogSortStore
