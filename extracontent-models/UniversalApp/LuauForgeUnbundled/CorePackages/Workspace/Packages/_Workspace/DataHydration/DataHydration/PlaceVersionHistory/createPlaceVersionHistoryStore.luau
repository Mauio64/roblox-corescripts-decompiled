local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createSingleEntityResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createSingleEntityResolver")

local fetchPlaceVersionHistory = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/PlaceVersionHistory/fetchPlaceVersionHistory")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/PlaceVersionHistory/PlaceVersionHistoryStoreTypes")

local function createPlaceVersionHistoryStore(options)
	local v5 = options or {}
	local v6 = {
		network = v5.network,
		baseUrl = v5.baseUrl,
		developBaseUrl = v5.developBaseUrl
	}

	local v7 = createSingleEntityResolver(function(p2)
		return fetchPlaceVersionHistory.fetchHistory(p2, v6)
	end)

	local v8 = createSingleEntityResolver(function(p2)
		return fetchPlaceVersionHistory.fetchHistory(p2, v6, { isPublished = true, pageSize = 1 }):andThen(function(p3)
			return { placeVersion = p3.placeVersions[1] }
		end)
	end, {
		resolver = { replaceItems = true }
	})

	local v9 = {}

	local resolved = Promise.resolve()

	local function getFetchingMoreHistorySignal(p2)
		local fetchingMoreHistorySignal = v9[p2]

		if fetchingMoreHistorySignal == nil then
			local signal, v10 = Signals.createSignal(false)
			fetchingMoreHistorySignal = { getIsFetching = signal, setIsFetching = v10 }

			v9[p2] = fetchingMoreHistorySignal
		end

		return fetchingMoreHistorySignal
	end

	return {
		getHistory = v7.get,
		fetchHistory = v7.fetch,
		getAndFetchHistory = v7.getAndFetch,
		updateHistory = v7.update,
		fetchPageHistory = function(p2, p3)
			return fetchPlaceVersionHistory.fetchHistory(p2, v6, p3):andThen(function(p4)
				v7.update(p2, p4)
				return p4
			end)
		end,
		fetchMoreHistory = function(p2, p3)
			local data = v7.get(p2).data(false)
			local v10 = v9[p2]

			if v10 == nil then
				local signal, v11 = Signals.createSignal(false)
				v10 = { getIsFetching = signal, setIsFetching = v11 }

				v9[p2] = v10
			end

			if
				data == nil
				or not data.hasMore
				or data.nextCursor ~= p3
				or p3 == ""
				or v10.getIsFetching(false)
			then
				return resolved
			end

			v10.setIsFetching(true)

			local v11 = fetchPlaceVersionHistory.fetchHistory(p2, v6, {
				cursor = p3,
				pageSize = fetchPlaceVersionHistory.DEFAULT_HISTORY_PAGE_SIZE
			}):andThen(function(data2)
				if v7.get(p2).data(false) == data then
					v7.cache.replaceItem(tostring(p2), {
						hasMore = data2.hasMore and data2.nextCursor ~= p3,
						nextCursor = data2.nextCursor,
						placeVersions = Cryo.List.join(
							data.placeVersions or {},
							data2.placeVersions or {}
						)
					})
				end
			end)

			v11:finally(function()
				v10.setIsFetching(false)
			end)
			return v11
		end,
		getIsFetchingMoreHistory = function(p2)
			local v10 = v9[p2]

			if v10 == nil then
				local signal, v11 = Signals.createSignal(false)
				v10 = { getIsFetching = signal, setIsFetching = v11 }

				v9[p2] = v10
			end

			return v10.getIsFetching
		end,
		getLiveVersion = v8.get,
		fetchLiveVersion = v8.fetch,
		getAndFetchLiveVersion = v8.getAndFetch,
		revertVersion = function(p2, p3, p4)
			return fetchPlaceVersionHistory.revertVersion(p3, p4, v6):andThen(function(p5)
				v7.fetch(p2)
				return { assetId = p3, assetVersionNumber = p4 }
			end):catch(function(message)
				error(message)
			end)
		end,
		rollbackPlace = function(p2, p3, p4, p5)
			return fetchPlaceVersionHistory.rollbackPlace(p2, p3, p4, p5, v6):andThen(function(p6)
				v7.fetch(p2)
				return p6
			end):catch(function(message)
				error(message)
			end)
		end,
		addVersionNote = function(p2, p3, p4)
			return fetchPlaceVersionHistory.addVersionNote(p2, p3, p4, v6):andThen(function(p5)
				local data = v7.get(p2).data(false)

				if data == nil or typeof(data.placeVersions) ~= "table" then
					return p5
				end

				local v10 = {}

				for k, placeVersion in data.placeVersions do
					if placeVersion.version == p3 then
						local v11 = {}

						for k2, v12 in placeVersion do
							v11[k2] = v12
						end

						v11.title = p4.title
						v11.description = p4.description
						v10[k] = v11
					else
						v10[k] = placeVersion
					end
				end

				v7.cache.replaceItem(tostring(p2), {
					hasMore = data.hasMore,
					nextCursor = data.nextCursor,
					placeVersions = v10
				})

				return p5
			end)
		end,
		clear = function()
			v7.clear()
			v8.clear()
		end,
		dispose = function()
			v7.dispose()
			v8.dispose()
		end
	}
end

return createPlaceVersionHistoryStore
