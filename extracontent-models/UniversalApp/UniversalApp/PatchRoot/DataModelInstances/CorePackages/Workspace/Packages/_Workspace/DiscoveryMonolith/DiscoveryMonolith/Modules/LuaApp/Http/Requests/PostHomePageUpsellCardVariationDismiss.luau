local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local Url = require(Parent.Http).Url

return function(p1, p2) -- line: 13
	-- upvalues: HttpService (copy), Url (copy)
	assert(p1, "requestImpl is required")
	assert(p2, "upsellCardType is required")

	local json = HttpService:JSONEncode({
		cardType = p2
	})

	return p1(string.format("%supsellcard/dismiss", Url.APIS_URL), "POST", {
		postBody = json
	})
end
