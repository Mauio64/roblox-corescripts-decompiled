local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydrationParent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)
local fetchExperienceGuidelines = require(script.Parent.fetchExperienceGuidelines)
local syncGuidelinesAgeToGameStores = require(script.Parent.syncGuidelinesAgeToGameStores).syncGuidelinesAgeToGameStores

require(script.Parent.ExperienceGuidelinesStoreTypes)

local function createExperienceGuidelinesStore(t1: {[any]: any}?) -- line: 20
	-- upvalues: createSingleEntityResolver (copy), fetchExperienceGuidelines (copy), syncGuidelinesAgeToGameStores (copy)
	local v8 = t1 or {}
	local t2 = {
		network = v8.network,
		baseUrl = v8.baseUrl
	}
	local v10 = createSingleEntityResolver(function(n1: number) -- line: 24
		-- upvalues: fetchExperienceGuidelines (copy), t2 (copy), syncGuidelinesAgeToGameStores (copy)
		return fetchExperienceGuidelines.fetchDetailedGuidelines(n1, t2):andThen(function(p1) -- line: 27
			-- upvalues: syncGuidelinesAgeToGameStores (copy), n1 (copy)
			syncGuidelinesAgeToGameStores(n1, p1)

			return p1
		end)
	end)

	return {
		getDetailedGuidelines = v10.get,
		fetchDetailedGuidelines = v10.fetch,
		refreshDetailedGuidelines = function(n2: number) -- line: 33
			-- upvalues: fetchExperienceGuidelines (copy), t2 (copy), v10 (copy), syncGuidelinesAgeToGameStores (copy)
			return fetchExperienceGuidelines.fetchDetailedGuidelines(n2, t2):andThen(function(p2) -- line: 36
				-- upvalues: v10 (copy), n2 (copy), syncGuidelinesAgeToGameStores (copy)
				v10.cache.replaceItem(tostring(n2), p2)
				syncGuidelinesAgeToGameStores(n2, p2)

				return p2
			end)
		end,
		getAndFetchDetailedGuidelines = v10.getAndFetch,
		updateDetailedGuidelines = function(n3: number, p3) -- line: 48
			-- upvalues: v10 (copy), syncGuidelinesAgeToGameStores (copy)
			v10.update(n3, p3)
			syncGuidelinesAgeToGameStores(n3, p3)
		end,
		clear = v10.clear,
		dispose = v10.dispose
	}
end

return createExperienceGuidelinesStore
