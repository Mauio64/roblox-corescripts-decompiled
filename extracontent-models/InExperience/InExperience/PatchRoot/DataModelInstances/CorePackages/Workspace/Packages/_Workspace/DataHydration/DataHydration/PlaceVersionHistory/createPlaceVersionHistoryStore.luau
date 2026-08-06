local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydrationParent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)
local fetchPlaceVersionHistory = require(script.Parent.fetchPlaceVersionHistory)

require(script.Parent.PlaceVersionHistoryStoreTypes)

local function createPlaceVersionHistoryStore(t1: {[any]: any}?) -- line: 20
	-- upvalues: createSingleEntityResolver (copy), fetchPlaceVersionHistory (copy)
	local v7 = t1 or {}
	local t2 = {
		network = v7.network,
		baseUrl = v7.baseUrl,
		developBaseUrl = v7.developBaseUrl
	}
	local v9 = createSingleEntityResolver(function(n1: number) -- line: 28
		-- upvalues: fetchPlaceVersionHistory (copy), t2 (copy)
		return fetchPlaceVersionHistory.fetchHistory(n1, t2)
	end)

	return {
		getHistory = v9.get,
		fetchHistory = v9.fetch,
		getAndFetchHistory = v9.getAndFetch,
		updateHistory = v9.update,
		fetchPageHistory = function(n2: number, p1) -- line: 32
			-- upvalues: fetchPlaceVersionHistory (copy), t2 (copy), v9 (copy)
			return fetchPlaceVersionHistory.fetchHistory(n2, t2, p1):andThen(function(p2) -- line: 38
				-- upvalues: v9 (copy), n2 (copy)
				v9.update(n2, p2)

				return p2
			end)
		end,
		revertVersion = function(n3: number, n4: number, n5: number) -- line: 44
			-- upvalues: fetchPlaceVersionHistory (copy), t2 (copy), v9 (copy)
			return fetchPlaceVersionHistory.revertVersion(n4, n5, t2):andThen(function(_) -- line: 51
				-- upvalues: n4 (copy), n5 (copy), v9 (copy), n3 (copy)
				local t3 = {
					assetId = n4,
					assetVersionNumber = n5
				}

				v9.fetch(n3)

				return t3
			end):catch(function(p4) -- line: 60
				error(p4)
			end)
		end,
		rollbackPlace = function(n6: number, n7: number, s1: string?, b1: boolean?) -- line: 65
			-- upvalues: fetchPlaceVersionHistory (copy), t2 (copy), v9 (copy)
			return fetchPlaceVersionHistory.rollbackPlace(n6, n7, s1, b1, t2):andThen(function(p5) -- line: 73
				-- upvalues: v9 (copy), n6 (copy)
				v9.fetch(n6)

				return p5
			end):catch(function(p6) -- line: 77
				error(p6)
			end)
		end,
		addVersionNote = function(n8: number, s2: string, p7) -- line: 82
			-- upvalues: fetchPlaceVersionHistory (copy), t2 (copy), v9 (copy)
			return fetchPlaceVersionHistory.addVersionNote(n8, s2, p7, t2):andThen(function(p8) -- line: 89
				-- upvalues: v9 (copy), n8 (copy), s2 (copy), p7 (copy)
				local v30 = v9.get(n8).data(false)

				if v30 == nil or typeof(v30.placeVersions) ~= "table" then
					return p8
				end

				local t4 = {}

				for v32, v33 in v30.placeVersions do
					if v33.version == s2 then
						local t5 = {}

						for v35, v36 in v33 do
							t5[v35] = v36
						end

						t5.title = p7.title
						t5.description = p7.description
						t4[v32] = t5
					else
						t4[v32] = v33
					end
				end

				v9.cache.replaceItem(tostring(n8), {
					hasMore = v30.hasMore,
					nextCursor = v30.nextCursor,
					placeVersions = t4
				})

				return p8
			end)
		end,
		clear = v9.clear,
		dispose = v9.dispose
	}
end

return createPlaceVersionHistoryStore
