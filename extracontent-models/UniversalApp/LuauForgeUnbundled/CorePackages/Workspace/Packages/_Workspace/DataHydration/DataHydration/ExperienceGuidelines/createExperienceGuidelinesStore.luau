require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local createSingleEntityResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createSingleEntityResolver")

local fetchExperienceGuidelines = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceGuidelines/fetchExperienceGuidelines")
local syncGuidelinesAgeToGameStores = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceGuidelines/syncGuidelinesAgeToGameStores").syncGuidelinesAgeToGameStores
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceGuidelines/ExperienceGuidelinesStoreTypes")

local function createExperienceGuidelinesStore(options)
	local v5 = options or {}
	local v6 = { network = v5.network, baseUrl = v5.baseUrl }

	local v7 = createSingleEntityResolver(function(p2)
		return fetchExperienceGuidelines.fetchDetailedGuidelines(p2, v6):andThen(function(p3)
			syncGuidelinesAgeToGameStores(p2, p3)
			return p3
		end)
	end)

	return {
		getDetailedGuidelines = v7.get,
		fetchDetailedGuidelines = v7.fetch,
		refreshDetailedGuidelines = function(p2)
			return fetchExperienceGuidelines.fetchDetailedGuidelines(p2, v6):andThen(function(p3)
				v7.cache.replaceItem(tostring(p2), p3)
				syncGuidelinesAgeToGameStores(p2, p3)
				return p3
			end)
		end,
		getAndFetchDetailedGuidelines = v7.getAndFetch,
		updateDetailedGuidelines = function(p2, p3)
			v7.update(p2, p3)
			syncGuidelinesAgeToGameStores(p2, p3)
		end,
		clear = v7.clear,
		dispose = v7.dispose
	}
end

return createExperienceGuidelinesStore
