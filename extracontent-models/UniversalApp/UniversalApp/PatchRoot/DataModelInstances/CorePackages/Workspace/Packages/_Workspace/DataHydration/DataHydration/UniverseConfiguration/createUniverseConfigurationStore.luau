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
	local v10 = createSingleEntityResolver(function(n1: number) -- line: 27
		-- upvalues: fetchUniverseConfiguration (copy), t2 (copy)
		return fetchUniverseConfiguration.fetchSummary(n1, t2)
	end)
	local v11 = createSingleEntityResolver(function(n2: number) -- line: 30
		-- upvalues: fetchUniverseConfiguration (copy), t2 (copy)
		return fetchUniverseConfiguration.fetchConfiguration(n2, t2)
	end)
	local v12 = createSingleEntityResolver(function(n3: number) -- line: 33
		-- upvalues: fetchUniverseConfiguration (copy), t2 (copy)
		return fetchUniverseConfiguration.fetchTeamCreate(n3, t2)
	end)

	return {
		getSummary = v10.get,
		fetchSummary = v10.fetch,
		getAndFetchSummary = v10.getAndFetch,
		updateSummary = v10.update,
		getConfiguration = v11.get,
		fetchConfiguration = v11.fetch,
		getAndFetchConfiguration = v11.getAndFetch,
		updateConfiguration = function(n4: number, p1) -- line: 37
			-- upvalues: v11 (copy), Cryo (copy)
			local v18 = v11.get(n4).data(false)

			if v18 == nil then
				return
			end

			local v19 = Cryo.Dictionary.join(v18, p1)

			v11.update(n4, v19)
		end,
		patchConfiguration = function(n5: number, p2) -- line: 47
			-- upvalues: fetchUniverseConfiguration (copy), t2 (copy), v11 (copy), Cryo (copy)
			return fetchUniverseConfiguration.patchConfiguration(n5, p2, t2):andThen(function(p3) -- line: 53
				-- upvalues: v11 (copy), n5 (copy), Cryo (copy)
				local v25 = v11.get(n5).data(false)
				local v26 = if v25 == nil then p3 else Cryo.Dictionary.join(v25, p3)

				v11.update(n5, v26)

				return v26
			end)
		end,
		getTeamCreate = v12.get,
		fetchTeamCreate = v12.fetch,
		getAndFetchTeamCreate = v12.getAndFetch,
		setTeamCreate = function(n6: number, b1: boolean) -- line: 63
			-- upvalues: fetchUniverseConfiguration (copy), t2 (copy), v12 (copy)
			return fetchUniverseConfiguration.setTeamCreate(n6, b1, t2):andThen(function(p4) -- line: 64
				-- upvalues: v12 (copy), n6 (copy)
				v12.update(n6, p4)

				return p4
			end)
		end,
		clear = function() -- line: 70
			-- upvalues: v10 (copy), v11 (copy), v12 (copy)
			v10.clear()
			v11.clear()
			v12.clear()
		end,
		dispose = function() -- line: 76
			-- upvalues: v10 (copy), v11 (copy), v12 (copy)
			v10.dispose()
			v11.dispose()
			v12.dispose()
		end
	}
end

return createUniverseConfigurationStore
