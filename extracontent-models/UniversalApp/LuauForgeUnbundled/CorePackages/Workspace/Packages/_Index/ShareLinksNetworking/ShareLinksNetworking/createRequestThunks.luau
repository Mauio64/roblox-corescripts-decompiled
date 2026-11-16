require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksNetworking/ShareLinksNetworking/networkingShareLinkTypes")

local createGenerateLink = require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksNetworking/ShareLinksNetworking/networkRequests/createGenerateLink")
local createGetOrGenerateLink = require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksNetworking/ShareLinksNetworking/networkRequests/createGetOrGenerateLink")
local createResolveLinkFromLinkId = require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksNetworking/ShareLinksNetworking/networkRequests/createResolveLinkFromLinkId")
local createResolveLinkFromLinkIdV2 = require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksNetworking/ShareLinksNetworking/networkRequests/createResolveLinkFromLinkIdV2")
local createGetMetadata = require("@game/CorePackages/Workspace/Packages/_Index/ShareLinksNetworking/ShareLinksNetworking/networkRequests/createGetMetadata")

return function(p2)
	return {
		GenerateLink = createGenerateLink(p2),
		GetOrGenerateLink = createGetOrGenerateLink(p2),
		ResolveLinkFromLinkId = createResolveLinkFromLinkId(p2),
		ResolveLinkFromLinkIdV2 = createResolveLinkFromLinkIdV2(p2),
		GetMetadata = createGetMetadata(p2)
	}
end
