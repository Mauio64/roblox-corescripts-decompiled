require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryUtils/LuauPolyfill")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryUtils/Promise")
local DiscoveryClientAppStorage = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryUtils/DiscoveryUtils/DiscoveryClientAppStorage")

local function makeDiscoveryNetworkCallWithCacheFallback(object, p2, p3)
	return object:andThen(function(p4)
		return p4
	end):catch(function(p4)
		local success, result = pcall(function()
			return DiscoveryClientAppStorage.getJsonStorageData(p2, p3)
		end)

		if not success then
			return Promise.reject(result)
		end

		if result then
			return Promise.resolve({ responseBody = result, isFromCache = true })
		end

		return Promise.reject(p4)
	end)
end

return makeDiscoveryNetworkCallWithCacheFallback
