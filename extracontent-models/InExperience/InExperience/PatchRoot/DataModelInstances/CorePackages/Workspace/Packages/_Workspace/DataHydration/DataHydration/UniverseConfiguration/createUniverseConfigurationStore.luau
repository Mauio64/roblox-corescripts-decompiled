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
			local v37 = t3[n2]

			if v37 == nil then
				return p1
			end

			if v17 <= v37.generation then
				return Cryo.Dictionary.join(p1, v37.patch)
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
		refreshSummary = function(n5: number) -- line: 93
			-- upvalues: fetchUniverseConfiguration (copy), t2 (copy), v12 (copy)
			return fetchUniverseConfiguration.fetchSummary(n5, t2):andThen(function(p3) -- line: 94
				-- upvalues: v12 (copy), n5 (copy)
				v12.cache.replaceItem(tostring(n5), p3)

				return p3
			end)
		end,
		getAndFetchSummary = v12.getAndFetch,
		updateSummary = function(n6: number, p4) -- line: 81
			-- upvalues: v12 (copy), Cryo (copy)
			local v28 = v12.get(n6).data(false)

			if v28 == nil then
				return
			end

			local v29 = Cryo.Dictionary.join(v28, p4)

			v12.update(n6, v29)
		end,
		getConfiguration = v13.get,
		fetchConfiguration = v13.fetch,
		refreshConfiguration = function(n7: number) -- line: 100
			-- upvalues: fetchUniverseConfiguration (copy), t2 (copy), v13 (copy)
			return fetchUniverseConfiguration.fetchConfiguration(n7, t2):andThen(function(p5) -- line: 103
				-- upvalues: v13 (copy), n7 (copy)
				v13.cache.replaceItem(tostring(n7), p5)

				return p5
			end)
		end,
		getAndFetchConfiguration = v13.getAndFetch,
		updateConfiguration = function(n8: number, p6) -- line: 71
			-- upvalues: v13 (copy), Cryo (copy)
			local v24 = v13.get(n8).data(false)

			if v24 == nil then
				return
			end

			local v25 = Cryo.Dictionary.join(v24, p6)

			v13.update(n8, v25)
		end,
		patchConfiguration = function(n9: number, p7) -- line: 109
			-- upvalues: fetchUniverseConfiguration (copy), t2 (copy), v13 (copy), getSummaryPatch (copy), v12 (copy), t3 (ref), n1 (ref), Cryo (copy)
			return fetchUniverseConfiguration.patchConfiguration(n9, p7, t2):andThen(function(p8) -- line: 115
				-- upvalues: v13 (copy), n9 (copy), p7 (copy), getSummaryPatch (copy), v12 (copy), t3 (ref), n1 (ref), Cryo (copy)
				v13.update(n9, p8)
				v13.update(n9, p7)

				local v41 = getSummaryPatch(p7)

				if v41 ~= nil and v12.get(n9).data(false) ~= nil then
					t3[n9] = {
						generation = n1,
						patch = v41
					}

					local v42 = n9
					local v43 = v12.get(v42).data(false)

					if v43 ~= nil then
						local v44 = Cryo.Dictionary.join(v43, v41)

						v12.update(v42, v44)
					end
				end

				return (v13.get(n9).data(false))
			end)
		end,
		getTeamCreate = v14.get,
		fetchTeamCreate = v14.fetch,
		getAndFetchTeamCreate = v14.getAndFetch,
		setTeamCreate = function(n10: number, b1: boolean) -- line: 132
			-- upvalues: fetchUniverseConfiguration (copy), t2 (copy), v14 (copy)
			return fetchUniverseConfiguration.setTeamCreate(n10, b1, t2):andThen(function(p9) -- line: 133
				-- upvalues: v14 (copy), n10 (copy)
				v14.update(n10, p9)

				return p9
			end)
		end,
		clear = function() -- line: 139
			-- upvalues: n1 (ref), t3 (ref), v12 (copy), v13 (copy), v14 (copy)
			n1 = 0
			t3 = {}
			v12.clear()
			v13.clear()
			v14.clear()
		end,
		dispose = function() -- line: 147
			-- upvalues: v12 (copy), v13 (copy), v14 (copy)
			v12.dispose()
			v13.dispose()
			v14.dispose()
		end
	}
end

return createUniverseConfigurationStore
