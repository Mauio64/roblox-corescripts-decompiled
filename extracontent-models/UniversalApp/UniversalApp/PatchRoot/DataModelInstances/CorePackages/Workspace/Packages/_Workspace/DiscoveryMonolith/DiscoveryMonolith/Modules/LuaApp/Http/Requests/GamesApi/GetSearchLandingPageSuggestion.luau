local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local Url = require(Parent.Http).Url

return function(p1, p2) -- line: 20
	-- upvalues: Url (copy)
	local APIS_URL = Url.APIS_URL
	local v6 = Url:makeQueryString(p2)

	return p1(string.format("%ssearch-landing-page-api/v1?%s", APIS_URL, v6), "GET")
end
