local ParentParent = script.Parent.Parent
local API_URL = require(ParentParent.API_URL)

require(ParentParent.networkingShareLinkTypes)

return function(p1) -- line: 6
	-- upvalues: API_URL (copy)
	return (p1.roduxNetworking.POST({
		Name = "resolve"
	}, function(p2, p3) -- line: 11
		-- upvalues: API_URL (copy)
		return p2(API_URL):path("deeplinks"):path("v2"):path("resolve"):body({
			linkId = p3.linkId
		})
	end))
end
