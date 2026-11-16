local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Cryo = require(parent.Cryo)
require(parent.HttpClient)
local Promise = require(parent.Promise)
local Signals = require(parent.Signals)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)

local fetchPlaceVersionHistory = require(script.Parent.fetchPlaceVersionHistory)
require(script.Parent.PlaceVersionHistoryStoreTypes)

local function createPlaceVersionHistoryStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl, developBaseUrl = v.developBaseUrl }

	local singleEntityResolver = createSingleEntityResolver(function(p: number)
		return fetchPlaceVersionHistory.fetchHistory(p, v2)
	end)

	local singleEntityResolver2 = createSingleEntityResolver(function(p: number)
		return fetchPlaceVersionHistory.fetchHistory(p, v2, { isPublished = true, pageSize = 1 }):andThen(function(p2)
			return { placeVersion = p2.placeVersions[1] }
		end)
	end, {
		resolver = { replaceItems = true }
	})

	local fetchingMoreHistorySignals = {}

	local resolved = Promise.resolve()

	local function getFetchingMoreHistorySignal(p: number) -- 2 equivalent calls inferred from this helper
		local fetchingMoreHistorySignal = fetchingMoreHistorySignals[p]

		if fetchingMoreHistorySignal == nil then
			local signal, setIsFetching = Signals.createSignal(false)
			fetchingMoreHistorySignal = { getIsFetching = signal, setIsFetching = setIsFetching }

			fetchingMoreHistorySignals[p] = fetchingMoreHistorySignal
		end

		return fetchingMoreHistorySignal
	end

	return {
		getHistory = singleEntityResolver.get,
		fetchHistory = singleEntityResolver.fetch,
		getAndFetchHistory = singleEntityResolver.getAndFetch,
		updateHistory = singleEntityResolver.update,
		fetchPageHistory = function(p: number, p2)
			return fetchPlaceVersionHistory.fetchHistory(p, v2, p2):andThen(function(p3)
				singleEntityResolver.update(p, p3)
				return p3
			end)
		end,
		fetchMoreHistory = function(p: number, cursor: string)
			local data = singleEntityResolver.get(p).data(false)
			local fetchingMoreHistorySignal = getFetchingMoreHistorySignal(p) -- inferred equivalent call

			if
				data == nil
				or not data.hasMore
				or data.nextCursor ~= cursor
				or cursor == ""
				or fetchingMoreHistorySignal.getIsFetching(false)
			then
				return resolved
			end

			fetchingMoreHistorySignal.setIsFetching(true)

			local v3 = fetchPlaceVersionHistory.fetchHistory(p, v2, {
				cursor = cursor,
				pageSize = fetchPlaceVersionHistory.DEFAULT_HISTORY_PAGE_SIZE
			}):andThen(function(data2)
				if singleEntityResolver.get(p).data(false) == data then
					singleEntityResolver.cache.replaceItem(tostring(p), {
						hasMore = data2.hasMore and data2.nextCursor ~= cursor,
						nextCursor = data2.nextCursor,
						placeVersions = Cryo.List.join(data.placeVersions or {}, data2.placeVersions or {})
					})
				end
			end)

			v3:finally(function()
				fetchingMoreHistorySignal.setIsFetching(false)
			end)
			return v3
		end,
		getIsFetchingMoreHistory = function(p: number)
			return getFetchingMoreHistorySignal(p).getIsFetching -- inferred equivalent call
		end,
		getLiveVersion = singleEntityResolver2.get,
		fetchLiveVersion = singleEntityResolver2.fetch,
		getAndFetchLiveVersion = singleEntityResolver2.getAndFetch,
		revertVersion = function(p: number, assetId: number, assetVersionNumber: number)
			return fetchPlaceVersionHistory.revertVersion(assetId, assetVersionNumber, v2):andThen(function(_)
				singleEntityResolver.fetch(p)
				return { assetId = assetId, assetVersionNumber = assetVersionNumber }
			end):catch(function(message)
				error(message)
			end)
		end,
		rollbackPlace = function(p: number, p2: number, p3: string?, flag: boolean?)
			return fetchPlaceVersionHistory.rollbackPlace(p, p2, p3, flag, v2):andThen(function(p4)
				singleEntityResolver.fetch(p)
				return p4
			end):catch(function(message)
				error(message)
			end)
		end,
		addVersionNote = function(p: number, p2: string, p3)
			return fetchPlaceVersionHistory.addVersionNote(p, p2, p3, v2):andThen(function(p4)
				local data = singleEntityResolver.get(p).data(false)

				if data == nil or typeof(data.placeVersions) ~= "table" then
					return p4
				end

				local placeVersions = {}

				for k, placeVersion in data.placeVersions do
					if placeVersion.version == p2 then
						local v3 = {}

						for k2, v4 in placeVersion do
							v3[k2] = v4
						end

						v3.title = p3.title
						v3.description = p3.description
						placeVersions[k] = v3
					else
						placeVersions[k] = placeVersion
					end
				end

				singleEntityResolver.cache.replaceItem(tostring(p), {
					hasMore = data.hasMore,
					nextCursor = data.nextCursor,
					placeVersions = placeVersions
				})

				return p4
			end)
		end,
		clear = function()
			singleEntityResolver.clear()
			singleEntityResolver2.clear()
		end,
		dispose = function()
			singleEntityResolver.dispose()
			singleEntityResolver2.dispose()
		end
	}
end

return createPlaceVersionHistoryStore
