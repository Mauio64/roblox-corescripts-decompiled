local Parent = script:FindFirstAncestor("Charts").Parent
local AddSystemInfoToArgs = require(Parent.DiscoveryUtils).AddSystemInfoToArgs
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = require(Parent.Http).Url
local v5 = UrlBuilder.new({
	path = "charts-api/v1/charts-sort-detail",
	base = Url.APIS_URL
})

local function getChartsSortDetailUrl(t1: {[any]: any}) -- line: 13
	-- upvalues: AddSystemInfoToArgs (copy), UrlBuilder (copy), v5 (copy)
	local t2 = {}

	AddSystemInfoToArgs(t2)
	t2.sortId = t1.sortId

	if t1.contentPageToken and t1.contentPageToken ~= "" then
		t2.contentPageToken = t1.contentPageToken
	end

	if t1.sessionId and t1.sessionId ~= "" then
		t2.sessionId = t1.sessionId
	end

	if t1.filterSelections then
		for v9, v10 in t1.filterSelections do
			t2[v9] = v10
		end
	end

	return UrlBuilder.addQueryString(v5(), t2)
end

return getChartsSortDetailUrl
