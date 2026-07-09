local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local Url = require(Parent.Http).Url
local AddSystemInfoToArgs = require(Parent.DiscoveryUtils).AddSystemInfoToArgs

return function(p1, p2) -- line: 55
	-- upvalues: HttpService (copy), Url (copy), AddSystemInfoToArgs (copy)
	if p2 and p2.searchQuery then
		p2.searchQuery = HttpService:UrlEncode(p2.searchQuery)
	elseif p2 and p2.SearchQuery then
		p2.SearchQuery = HttpService:UrlEncode(p2.SearchQuery)
	end

	local APIS_URL = Url.APIS_URL

	AddSystemInfoToArgs(p2)

	local v8 = Url:makeQueryString(p2)

	return p1(string.format("%ssearch-api/omni-search?%s", APIS_URL, v8), "GET")
end
