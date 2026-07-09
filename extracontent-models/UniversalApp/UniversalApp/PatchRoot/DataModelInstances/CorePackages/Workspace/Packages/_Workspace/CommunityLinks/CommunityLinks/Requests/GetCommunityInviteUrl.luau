local Parent = script:FindFirstAncestor("CommunityLinks").Parent
local Url = require(Parent.Http).Url
local v3 = require(Parent.UrlBuilder).UrlBuilder.new({
	path = "community-links/v1/guilded/{communityId}/join",
	base = Url.APIS_URL,
	query = {
		a = "red",
		skipRedirect = "true"
	}
})

return function(p1, s1: string) -- line: 18
	-- upvalues: v3 (copy)
	return p1(v3({
		communityId = s1
	}), "GET")
end
