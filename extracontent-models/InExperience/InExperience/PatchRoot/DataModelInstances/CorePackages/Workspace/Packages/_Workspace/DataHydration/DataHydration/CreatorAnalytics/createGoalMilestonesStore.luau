local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local fetchGoalMilestones = require(script.Parent.fetchGoalMilestones)
require(script.Parent.GoalMilestonesTypes)

local function createGoalMilestonesStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }

	local dataResolver = createDataResolver({
		cache = createDataCache(v.ttlSeconds),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p: string, _)
			return fetchGoalMilestones(tonumber(p), v2)
		end
	})

	return {
		getAndFetchGoalMilestones = function(p: number)
			return (dataResolver.getAndFetchItem((tostring(p))))
		end,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createGoalMilestonesStore
