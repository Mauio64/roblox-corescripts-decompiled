require(script.Parent.networkingShareLinkTypes)

local networkRequests = script.Parent.networkRequests
local createGenerateLink = require(networkRequests.createGenerateLink)
local createGetOrGenerateLink = require(networkRequests.createGetOrGenerateLink)
local createResolveLinkFromLinkId = require(networkRequests.createResolveLinkFromLinkId)

return function(p)
	return {
		ResolveLinkFromLinkId = createResolveLinkFromLinkId(p),
		GenerateLink = createGenerateLink(p),
		GetOrGenerateLink = createGetOrGenerateLink(p)
	}
end
