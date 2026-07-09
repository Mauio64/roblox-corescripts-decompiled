local Parent = script:FindFirstAncestor("DevStore").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = require(Parent.Http).Url
local v4 = UrlBuilder.new({
	path = "experience-store/v1beta1/universes/{universeId}/dev-store-see-all",
	base = Url.APIS_URL
})

local function getDevStoreSeeAllUrl(s1: string) -- line: 12
	-- upvalues: v4 (copy)
	return v4({
		universeId = s1
	})
end

return getDevStoreSeeAllUrl
