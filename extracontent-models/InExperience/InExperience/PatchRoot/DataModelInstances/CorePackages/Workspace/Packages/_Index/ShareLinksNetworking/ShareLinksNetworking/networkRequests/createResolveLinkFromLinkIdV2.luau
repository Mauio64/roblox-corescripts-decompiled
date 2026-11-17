local parent = script.Parent.Parent

local API_URL = require(parent.API_URL)
require(parent.networkingShareLinkTypes)

return function(p)
	return (p.roduxNetworking.POST("resolve", function(callback, p2)
		return callback(API_URL):path("deeplinks"):path("v2"):path("resolve"):body({
			linkId = p2.linkId,
			skipFilterCheck = p2.skipFilterCheck
		})
	end))
end
