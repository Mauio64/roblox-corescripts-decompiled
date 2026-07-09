local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local Url = require(Parent.Http).Url

return function(p1, s1: string) -- line: 6
	-- upvalues: Url (copy)
	return p1(string.format("%sv1/sponsored-games/click", Url.ADS_URL), "POST", {
		postBody = "\"" .. s1 .. "\""
	})
end
