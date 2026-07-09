local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = require(Parent.Http).Url
local FFlagLuaAppChartsAppPage = require(Parent.SharedFlags).FFlagLuaAppChartsAppPage
local v5 = UrlBuilder.new({
	base = Url.APIS_URL,
	path = not FFlagLuaAppChartsAppPage and "/explore-api/v1/get-sorts-metadata" or "/charts-api/v1/get-sorts-metadata"
})

return function(p1, p2) -- line: 33
	-- upvalues: UrlBuilder (copy), v5 (copy)
	return p1(UrlBuilder.addQueryString(v5(), {
		sessionId = p2
	}), "GET")
end
