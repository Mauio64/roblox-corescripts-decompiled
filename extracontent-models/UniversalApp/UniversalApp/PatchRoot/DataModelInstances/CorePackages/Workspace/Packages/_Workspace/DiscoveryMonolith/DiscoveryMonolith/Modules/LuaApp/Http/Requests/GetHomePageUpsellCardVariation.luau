local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local Url = require(Parent.Http).Url

return function(p1) -- line: 17
	-- upvalues: Url (copy)
	return p1(string.format("%supsellcard/type", Url.APIS_URL), "GET")
end
