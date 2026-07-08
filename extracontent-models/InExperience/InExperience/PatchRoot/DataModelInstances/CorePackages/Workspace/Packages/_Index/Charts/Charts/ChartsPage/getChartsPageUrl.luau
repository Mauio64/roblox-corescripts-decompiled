local Parent = script:FindFirstAncestor("Charts").Parent
local AddSystemInfoToArgs = require(Parent.DiscoveryUtils).AddSystemInfoToArgs
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = require(Parent.Http).Url
local FFlagSduiChartsRequestPlaceholders = require(Parent.SharedFlags).FFlagSduiChartsRequestPlaceholders
local v6 = UrlBuilder.new({
	path = "charts-api/v1/charts-page",
	base = Url.APIS_URL
})

local function getChartsPageUrl(t1: {[any]: any}?) -- line: 14
	-- upvalues: AddSystemInfoToArgs (copy), FFlagSduiChartsRequestPlaceholders (copy), UrlBuilder (copy), v6 (copy)
	local t2 = {}

	AddSystemInfoToArgs(t2)

	if t1 then
		if t1.feedPageToken and t1.feedPageToken ~= "" then
			t2.feedPageToken = t1.feedPageToken
		end

		if t1.sessionId and t1.sessionId ~= "" then
			t2.sessionId = t1.sessionId
		end

		if t1.entryPaginationKey and t1.entryPaginationKey ~= "" then
			t2.entryPaginationKey = t1.entryPaginationKey
		end

		if t1.entryPageToken and t1.entryPageToken ~= "" then
			t2.entryPageToken = t1.entryPageToken
		end

		if t1.pageType and t1.pageType ~= "" then
			t2.pageType = t1.pageType
		end

		if t1.filterSelections then
			for v10, v11 in t1.filterSelections do
				t2[v10] = v11
			end
		end

		if FFlagSduiChartsRequestPlaceholders and t1.includePlaceholders then
			t2.includePlaceholders = "true"
		end
	end

	return UrlBuilder.addQueryString(v6(), t2)
end

return getChartsPageUrl
