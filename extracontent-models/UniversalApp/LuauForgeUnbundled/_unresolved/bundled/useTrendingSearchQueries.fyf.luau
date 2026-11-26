local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")
local module2 = require("@luauforge/bundled/fxu")
local module3 = require("@luauforge/bundled/fyg")

local module4 = require("@luauforge/bundled/fyh")

local useNetworking = module2.Hooks.useNetworking
local useSignalState = module3.useSignalState

local function useTrendingSearchQueries()
	local v5 = useNetworking()
	local v6 = module4(false)

	React.useEffect(function()
		return v6.fetchQueriesIfNeeded(v5)
	end, { v5, v6 })

	return useSignalState(v6.getQueries)
end

return useTrendingSearchQueries
