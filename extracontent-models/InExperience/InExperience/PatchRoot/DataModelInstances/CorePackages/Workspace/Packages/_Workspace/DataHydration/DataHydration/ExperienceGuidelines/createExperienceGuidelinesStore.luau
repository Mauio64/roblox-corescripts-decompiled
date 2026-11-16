local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)

local fetchExperienceGuidelines = require(script.Parent.fetchExperienceGuidelines)
local syncGuidelinesAgeToGameStores = require(script.Parent.syncGuidelinesAgeToGameStores)
local syncGuidelinesAgeToGameStores2 = syncGuidelinesAgeToGameStores.syncGuidelinesAgeToGameStores
require(script.Parent.ExperienceGuidelinesStoreTypes)

local function createExperienceGuidelinesStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }

	local singleEntityResolver = createSingleEntityResolver(function(p: number)
		return fetchExperienceGuidelines.fetchDetailedGuidelines(p, v2):andThen(function(p2)
			syncGuidelinesAgeToGameStores2(p, p2)
			return p2
		end)
	end)

	return {
		getDetailedGuidelines = singleEntityResolver.get,
		fetchDetailedGuidelines = singleEntityResolver.fetch,
		refreshDetailedGuidelines = function(p: number)
			return fetchExperienceGuidelines.fetchDetailedGuidelines(p, v2):andThen(function(p2)
				singleEntityResolver.cache.replaceItem(tostring(p), p2)
				syncGuidelinesAgeToGameStores2(p, p2)
				return p2
			end)
		end,
		getAndFetchDetailedGuidelines = singleEntityResolver.getAndFetch,
		updateDetailedGuidelines = function(p: number, p2)
			singleEntityResolver.update(p, p2)
			syncGuidelinesAgeToGameStores2(p, p2)
		end,
		clear = singleEntityResolver.clear,
		dispose = singleEntityResolver.dispose
	}
end

return createExperienceGuidelinesStore
