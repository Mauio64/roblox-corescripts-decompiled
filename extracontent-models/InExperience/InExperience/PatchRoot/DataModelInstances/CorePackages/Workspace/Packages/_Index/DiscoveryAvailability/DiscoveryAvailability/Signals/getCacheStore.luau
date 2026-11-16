local parent = script:FindFirstAncestor("DiscoveryAvailability").Parent

local Signals = require(parent.Signals)

require(script.Parent.CacheStoreTypes)

local function createCacheStore()
	local signal, setHomePageDataSource = Signals.createSignal(nil)

	return { getHomePageDataSource = signal, setHomePageDataSource = setHomePageDataSource }
end

return Signals.createComputed(createCacheStore)
