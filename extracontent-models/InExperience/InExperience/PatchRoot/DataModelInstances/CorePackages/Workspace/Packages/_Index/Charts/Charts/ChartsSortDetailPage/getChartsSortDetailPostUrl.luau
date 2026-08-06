local Parent = script:FindFirstAncestor("Charts").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = require(Parent.Http).Url
local v4 = UrlBuilder.new({
	path = "charts-api/v1/charts-sort-detail",
	base = Url.APIS_URL
})

local function getChartsSortDetailPostUrl() -- line: 16
	-- upvalues: v4 (copy)
	return v4()
end

return getChartsSortDetailPostUrl
