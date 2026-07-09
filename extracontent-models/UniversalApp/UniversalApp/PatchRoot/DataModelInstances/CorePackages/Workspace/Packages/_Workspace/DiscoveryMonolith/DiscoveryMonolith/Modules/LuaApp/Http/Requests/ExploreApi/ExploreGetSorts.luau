local Parent = script:FindFirstAncestor("DiscoveryMonolith").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = require(Parent.Http).Url
local GetFStringTopSongsSortExploreApiPageType = require(Parent.SharedFlags).GetFStringTopSongsSortExploreApiPageType
local FFlagEnableTopSongsSort = require(Parent.SharedFlags).FFlagEnableTopSongsSort
local FFlagLuaAppChartsAppPage = require(Parent.SharedFlags).FFlagLuaAppChartsAppPage
local v7 = UrlBuilder.new({
	base = Url.APIS_URL,
	path = not FFlagLuaAppChartsAppPage and "/explore-api/v1/get-sorts" or "/charts-api/v1/get-sorts"
})

return function(p1, p2, p3, p4) -- line: 35
	-- upvalues: FFlagEnableTopSongsSort (copy), GetFStringTopSongsSortExploreApiPageType (copy), UrlBuilder (copy), v7 (copy)
	local t1 = {
		sessionId = p4,
		sortsPageToken = p2
	}

	for v13, v14 in p3 do
		if t1[v13] then
			warn(`URL parameter { v13 } already exists`)
		else
			t1[v13] = v14
		end
	end

	if FFlagEnableTopSongsSort then
		t1.pageType = GetFStringTopSongsSortExploreApiPageType()
	end

	return p1(UrlBuilder.addQueryString(v7(), t1), "GET")
end
