local Parent = script:FindFirstAncestor("DiscoveryAvailability").Parent
local Signals = require(Parent.Signals)

require(script.Parent.CacheStoreTypes)

local function createCacheStore() -- line: 15
	-- upvalues: Signals (copy)
	local v4, v5 = Signals.createSignal(nil)

	return {
		getHomePageDataSource = v4,
		setHomePageDataSource = v5
	}
end

return Signals.createComputed(createCacheStore)
