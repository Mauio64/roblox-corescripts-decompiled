local DiscoveryUtils = script:FindFirstAncestor("DiscoveryUtils")
local DiscoveryUtilsParent = DiscoveryUtils.Parent

require(DiscoveryUtilsParent.LuauPolyfill)

local Promise = require(DiscoveryUtilsParent.Promise)
local DiscoveryClientAppStorage = require(DiscoveryUtils.DiscoveryClientAppStorage)

local function makeDiscoveryNetworkCallWithCacheFallback(p1, p2, n1: number) -- line: 20
	-- upvalues: DiscoveryClientAppStorage (copy), Promise (copy)
	return p1:andThen(function(p3) -- line: 26
		return p3
	end):catch(function(p4) -- line: 29
		-- upvalues: DiscoveryClientAppStorage (copy), p2 (copy), n1 (copy), Promise (copy)
		local ok, result = pcall(function() -- line: 30
			-- upvalues: DiscoveryClientAppStorage (copy), p2 (copy), n1 (copy)
			return DiscoveryClientAppStorage.getJsonStorageData(p2, n1)
		end)

		if not ok then
			return Promise.reject(result)
		end

		if result then
			return Promise.resolve({
				isFromCache = true,
				responseBody = result
			})
		end

		return Promise.reject(p4)
	end)
end

return makeDiscoveryNetworkCallWithCacheFallback
