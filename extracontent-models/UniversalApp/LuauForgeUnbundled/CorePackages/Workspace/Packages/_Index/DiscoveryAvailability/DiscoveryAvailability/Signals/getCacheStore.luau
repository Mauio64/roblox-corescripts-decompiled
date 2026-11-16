local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAvailability/Signals")

require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAvailability/DiscoveryAvailability/Signals/CacheStoreTypes")

local function createCacheStore()
	local signal, v5 = Signals.createSignal(nil)

	return { getHomePageDataSource = signal, setHomePageDataSource = v5 }
end

return Signals.createComputed(createCacheStore)
