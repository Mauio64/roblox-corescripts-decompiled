require(script.Parent.networkingShareLinkTypes)

local networkRequests = script.Parent.networkRequests
local createGenerateLink = require(networkRequests.createGenerateLink)
local createGetOrGenerateLink = require(networkRequests.createGetOrGenerateLink)
local createResolveLinkFromLinkId = require(networkRequests.createResolveLinkFromLinkId)
local createResolveLinkFromLinkIdV2 = require(networkRequests.createResolveLinkFromLinkIdV2)
local createGetMetadata = require(networkRequests.createGetMetadata)

return function(p)
	return {
		GenerateLink = createGenerateLink(p),
		GetOrGenerateLink = createGetOrGenerateLink(p),
		ResolveLinkFromLinkId = createResolveLinkFromLinkId(p),
		ResolveLinkFromLinkIdV2 = createResolveLinkFromLinkIdV2(p),
		GetMetadata = createGetMetadata(p)
	}
end
