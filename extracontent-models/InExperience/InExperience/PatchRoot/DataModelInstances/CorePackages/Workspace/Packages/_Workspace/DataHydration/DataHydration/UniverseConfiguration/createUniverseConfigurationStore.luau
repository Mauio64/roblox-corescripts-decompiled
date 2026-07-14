local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Cryo = require(DataHydrationParent.Cryo)

require(DataHydrationParent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)
local fetchUniverseConfiguration = require(script.Parent.fetchUniverseConfiguration)

require(script.Parent.UniverseConfigurationStoreTypes)

local function createUniverseConfigurationStore(t1: {[any]: any}?) -- line: 23
	-- upvalues: createSingleEntityResolver (copy), fetchUniverseConfiguration (copy), Cryo (copy)
	local v8 = t1 or {}
	local t2 = {
		network = v8.network,
		baseUrl = v8.baseUrl
	}
	local n1 = 0
	local t3 = {}
	local v12 = createSingleEntityResolver(function(n2: number) -- line: 29
		-- upvalues: n1 (ref), fetchUniverseConfiguration (copy), t2 (copy), t3 (ref), Cryo (copy)
		n1 += 1

		local v17 = n1

		return fetchUniverseConfiguration.fetchSummary(n2, t2):andThen(function(p1) -- line: 32
			-- upvalues: t3 (ref), n2 (copy), v17 (copy), Cryo (copy)
			local v31 = t3[n2]

			if v31 == nil then
				return p1
			end

			if v17 <= v31.generation then
				return Cryo.Dictionary.join(p1, v31.patch)
			end

			t3[n2] = nil

			return p1
		end)
	end)
	local v13 = createSingleEntityResolver(function(n3: number) -- line: 45
		-- upvalues: fetchUniverseConfiguration (copy), t2 (copy)
		return fetchUniverseConfiguration.fetchConfiguration(n3, t2)
	end)
	local v14 = createSingleEntityResolver(function(n4: number) -- line: 48
		-- upvalues: fetchUniverseConfiguration (copy), t2 (copy)
		return fetchUniverseConfiguration.fetchTeamCreate(n4, t2)
	end)

	local function getSummaryPatch(p2) -- line: 52
		local t4 = {}

		if p2.name ~= nil then
			t4.name = p2.name
		end

		if p2.description ~= nil then
			t4.description = p2.description
		end

		if p2.isArchived ~= nil then
			t4.isArchived = p2.isArchived
		end

		if next(t4) == nil then
			return nil
		end

		return t4
	end

	return {
		getSummary = v12.get,
		fetchSummary = v12.fetch,
		getAndFetchSummary = v12.getAndFetch,
		updateSummary = v12.update,
		getConfiguration = v13.get,
		fetchConfiguration = v13.fetch,
		getAndFetchConfiguration = v13.getAndFetch,
		updateConfiguration = function(n5: number, p3) -- line: 71
			-- upvalues: v13 (copy), Cryo (copy)
			local v24 = v13.get(n5).data(false)

			if v24 == nil then
				return
			end

			local v25 = Cryo.Dictionary.join(v24, p3)

			v13.update(n5, v25)
		end,
		patchConfiguration = function(n6: number, p4) -- line: 81
			-- upvalues: fetchUniverseConfiguration (copy), t2 (copy), v13 (copy), getSummaryPatch (copy), v12 (copy), t3 (ref), n1 (ref)
			return fetchUniverseConfiguration.patchConfiguration(n6, p4, t2):andThen(function(p5) -- line: 87
				-- upvalues: v13 (copy), n6 (copy), p4 (copy), getSummaryPatch (copy), v12 (copy), t3 (ref), n1 (ref)
				v13.update(n6, p5)
				v13.update(n6, p4)

				local v33 = getSummaryPatch(p4)

				if v33 ~= nil and v12.get(n6).data(false) ~= nil then
					t3[n6] = {
						generation = n1,
						patch = v33
					}
					v12.update(n6, v33)
				end

				return (v13.get(n6).data(false))
			end)
		end,
		getTeamCreate = v14.get,
		fetchTeamCreate = v14.fetch,
		getAndFetchTeamCreate = v14.getAndFetch,
		setTeamCreate = function(n7: number, b1: boolean) -- line: 104
			-- upvalues: fetchUniverseConfiguration (copy), t2 (copy), v14 (copy)
			return fetchUniverseConfiguration.setTeamCreate(n7, b1, t2):andThen(function(p6) -- line: 105
				-- upvalues: v14 (copy), n7 (copy)
				v14.update(n7, p6)

				return p6
			end)
		end,
		clear = function() -- line: 111
			-- upvalues: n1 (ref), t3 (ref), v12 (copy), v13 (copy), v14 (copy)
			n1 = 0
			t3 = {}
			v12.clear()
			v13.clear()
			v14.clear()
		end,
		dispose = function() -- line: 119
			-- upvalues: v12 (copy), v13 (copy), v14 (copy)
			v12.dispose()
			v13.dispose()
			v14.dispose()
		end
	}
end

return createUniverseConfigurationStore
