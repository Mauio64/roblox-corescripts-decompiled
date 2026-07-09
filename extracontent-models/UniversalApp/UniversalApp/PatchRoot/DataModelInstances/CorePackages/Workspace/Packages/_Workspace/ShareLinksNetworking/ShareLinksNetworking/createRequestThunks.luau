require(script.Parent.networkingShareLinkTypes)

local networkRequests = script.Parent.networkRequests
local createGenerateLink = require(networkRequests.createGenerateLink)
local createGetOrGenerateLink = require(networkRequests.createGetOrGenerateLink)
local createResolveLinkFromLinkId = require(networkRequests.createResolveLinkFromLinkId)
local createResolveLinkFromLinkIdV2 = require(networkRequests.createResolveLinkFromLinkIdV2)
local createGetMetadata = require(networkRequests.createGetMetadata)

return function(p1) -- line: 10
	-- upvalues: createGenerateLink (copy), createGetOrGenerateLink (copy), createResolveLinkFromLinkId (copy), createResolveLinkFromLinkIdV2 (copy), createGetMetadata (copy)
	return {
		GenerateLink = createGenerateLink(p1),
		GetOrGenerateLink = createGetOrGenerateLink(p1),
		ResolveLinkFromLinkId = createResolveLinkFromLinkId(p1),
		ResolveLinkFromLinkIdV2 = createResolveLinkFromLinkIdV2(p1),
		GetMetadata = createGetMetadata(p1)
	}
end
