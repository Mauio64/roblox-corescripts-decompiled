local API_URL = require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksNetworking/ShareLinksNetworking/API_URL")
require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksNetworking/ShareLinksNetworking/networkingShareLinkTypes")

local fFlagEnableConnectionsDeepLinkSkipFilterCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareLinksNetworking/SharedFlags").FFlagEnableConnectionsDeepLinkSkipFilterCheck

return function(p2)
	return (p2.roduxNetworking.POST("resolve", function(callback, p3)
		if fFlagEnableConnectionsDeepLinkSkipFilterCheck then
			return callback(API_URL):path("deeplinks"):path("v2"):path("resolve"):body({
				linkId = p3.linkId,
				skipFilterCheck = p3.skipFilterCheck
			})
		end

		return callback(API_URL):path("deeplinks"):path("v2"):path("resolve"):body({
			linkId = p3.linkId
		})
	end))
end
