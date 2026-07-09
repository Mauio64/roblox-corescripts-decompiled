local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = require(Parent.Http).Url
local FFlagLuaAppChartsAppPage = require(Parent.SharedFlags).FFlagLuaAppChartsAppPage
local v5 = UrlBuilder.new({
	base = Url.APIS_URL,
	path = not FFlagLuaAppChartsAppPage and "/explore-api/v1/get-sort-content" or "/charts-api/v1/get-sort-content"
})

return function(p1, p2) -- line: 36
	-- upvalues: UrlBuilder (copy), v5 (copy)
	return p1(UrlBuilder.addQueryString(v5(), p2), "GET")
end
