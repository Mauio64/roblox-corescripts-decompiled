local networkRequests = script.Parent.networkRequests
local createGetSocialLinks = require(networkRequests.createGetSocialLinks)
local createGetSelfSocialLinks = require(networkRequests.createGetSelfSocialLinks)
local createSetSocialLinks = require(networkRequests.createSetSocialLinks)

return function(t1: {[any]: any}) -- line: 7
	-- upvalues: createGetSocialLinks (copy), createGetSelfSocialLinks (copy), createSetSocialLinks (copy)
	return {
		GetSocialLinks = createGetSocialLinks(t1),
		GetSelfSocialLinks = createGetSelfSocialLinks(t1),
		SetSocialLinks = createSetSocialLinks(t1)
	}
end
