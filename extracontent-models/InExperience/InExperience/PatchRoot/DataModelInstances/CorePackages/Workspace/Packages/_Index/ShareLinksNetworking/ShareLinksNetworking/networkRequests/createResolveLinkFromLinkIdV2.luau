local parent = script.Parent.Parent
local parent2 = parent.Parent

local API_URL = require(parent.API_URL)
require(parent.networkingShareLinkTypes)

local SharedFlags = require(parent2.SharedFlags)
local FFlagEnableConnectionsDeepLinkSkipFilterCheck = SharedFlags.FFlagEnableConnectionsDeepLinkSkipFilterCheck

return function(p)
	return (p.roduxNetworking.POST("resolve", function(callback, p2)
		if FFlagEnableConnectionsDeepLinkSkipFilterCheck then
			return callback(API_URL):path("deeplinks"):path("v2"):path("resolve"):body({
				linkId = p2.linkId,
				skipFilterCheck = p2.skipFilterCheck
			})
		end

		return callback(API_URL):path("deeplinks"):path("v2"):path("resolve"):body({
			linkId = p2.linkId
		})
	end))
end
