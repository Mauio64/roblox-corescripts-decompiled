local networkRequests = script.Parent.networkRequests
local createGetSocialLinks = require(networkRequests.createGetSocialLinks)
local createGetSelfSocialLinks = require(networkRequests.createGetSelfSocialLinks)
local createSetSocialLinks = require(networkRequests.createSetSocialLinks)

return function(p)
	return {
		GetSocialLinks = createGetSocialLinks(p),
		GetSelfSocialLinks = createGetSelfSocialLinks(p),
		SetSocialLinks = createSetSocialLinks(p)
	}
end
