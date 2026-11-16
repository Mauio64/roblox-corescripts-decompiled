require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local fetchGoalMilestones = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/fetchGoalMilestones")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/GoalMilestonesTypes")

local function createGoalMilestonesStore(options)
	local v5 = options or {}
	local v6 = { network = v5.network, baseUrl = v5.baseUrl }

	local v8 = createDataResolver({
		cache = createDataCache(v5.ttlSeconds),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2, p3)
			return fetchGoalMilestones(tonumber(p2), v6)
		end
	})

	return {
		getAndFetchGoalMilestones = function(p2)
			return (v8.getAndFetchItem((tostring(p2))))
		end,
		clear = v8.clear,
		dispose = v8.dispose
	}
end

return createGoalMilestonesStore
