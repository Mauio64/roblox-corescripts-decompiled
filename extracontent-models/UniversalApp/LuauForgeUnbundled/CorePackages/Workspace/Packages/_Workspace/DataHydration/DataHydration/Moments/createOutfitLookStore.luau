local createSingleEntityResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createSingleEntityResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local fetchLookByOutfit = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Requests/fetchLookByOutfit")

local function createOutfitLookStore(p2)
	local v5 = createSingleEntityResolver(function(p3)
		return fetchLookByOutfit(p3, p2)
	end, {
		resolver = { replaceItems = true }
	})

	return {
		getCachedLookByOutfit = v5.get,
		getAndFetchLookByOutfit = v5.getAndFetch,
		clear = v5.clear,
		dispose = v5.dispose
	}
end

return createOutfitLookStore
