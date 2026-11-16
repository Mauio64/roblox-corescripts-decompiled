local DiscoveryUtils = script:FindFirstAncestor("DiscoveryUtils")
local parent = DiscoveryUtils.Parent
require(parent.LuauPolyfill)
local Promise = require(parent.Promise)
local DiscoveryClientAppStorage = require(DiscoveryUtils.DiscoveryClientAppStorage)

local function makeDiscoveryNetworkCallWithCacheFallback(object, p, p2: number)
	return object:andThen(function(p3)
		return p3
	end):catch(function(p3)
		local success, result = pcall(function()
			return DiscoveryClientAppStorage.getJsonStorageData(p, p2)
		end)

		if not success then
			return Promise.reject(result)
		end

		if result then
			return Promise.resolve({ responseBody = result, isFromCache = true })
		end

		return Promise.reject(p3)
	end)
end

return makeDiscoveryNetworkCallWithCacheFallback
