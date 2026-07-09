local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Promise = require(DataHydrationParent.Promise)
local createDataCache = require(DataHydration.createDataCache)

require(DataHydration.DataHydrationTypes)
require(script.Parent.CreatorInfoStoreTypes)

local createDataResolver = require(DataHydration.createDataResolver)

local function createCreatorInfoStore() -- line: 10
	-- upvalues: createDataCache (copy), createDataResolver (copy), Promise (copy)
	local v7 = createDataCache()
	local v8 = createDataResolver({
		cache = v7,
		fetchFn = function(_: {[any]: any}) -- line: 14
			-- upvalues: Promise (copy)
			return Promise.resolve({})
		end
	})

	return {
		getCreatorInfo = v8.getCachedItem,
		getCreatorInfos = v8.getCachedItems,
		updateCreatorInfo = v7.updateItem,
		updateCreatorInfos = v7.updateItems,
		clear = v7.clear,
		dispose = v7.dispose
	}
end

return createCreatorInfoStore
