local Parent = script:FindFirstAncestor("CommunityLinks").Parent
local Url = require(Parent.Http).Url
local v3 = require(Parent.UrlBuilder).UrlBuilder.new({
	path = "community-links/v1/universes/{universeId}/community",
	base = Url.APIS_URL
})

return function(p1, s1: string) -- line: 23
	-- upvalues: v3 (copy)
	return p1(v3({
		universeId = s1
	}), "GET")
end
