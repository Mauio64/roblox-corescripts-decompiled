require(script.Parent.networkingShareLinkTypes)

local networkRequests = script.Parent.networkRequests
local createGenerateLink = require(networkRequests.createGenerateLink)
local createGetOrGenerateLink = require(networkRequests.createGetOrGenerateLink)
local createResolveLinkFromLinkId = require(networkRequests.createResolveLinkFromLinkId)

return function(p1) -- line: 9
	-- upvalues: createResolveLinkFromLinkId (copy), createGenerateLink (copy), createGetOrGenerateLink (copy)
	return {
		ResolveLinkFromLinkId = createResolveLinkFromLinkId(p1),
		GenerateLink = createGenerateLink(p1),
		GetOrGenerateLink = createGetOrGenerateLink(p1)
	}
end
