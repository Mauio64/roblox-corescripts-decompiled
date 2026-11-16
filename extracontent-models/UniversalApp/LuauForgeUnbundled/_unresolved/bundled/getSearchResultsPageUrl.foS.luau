local HttpService = game:GetService("HttpService")
local url = require("@luauforge/bundled/foT").Url
local urlBuilder = require("@luauforge/bundled/foU").UrlBuilder
local addSystemInfoToArgs = require("@luauforge/bundled/foR").AddSystemInfoToArgs

local module = require("@luauforge/bundled/foP")
local fFlagLuaAppEnableSearchStreamingEndpoint = module.FFlagLuaAppEnableSearchStreamingEndpoint
local fFlagSduiSearchResultsForwardDeviceSignals = module.FFlagSduiSearchResultsForwardDeviceSignals
local v5

if fFlagSduiSearchResultsForwardDeviceSignals then
	v5 = urlBuilder.new({
		base = url.APIS_URL,
		path = fFlagLuaAppEnableSearchStreamingEndpoint and "search-api/v1/search-results-page-stream" or "search-api/v1/search-results-page"
	})
else
	v5 = nil
end

local function getSearchResultsPageUrl(p2, p3, p4)
	if fFlagSduiSearchResultsForwardDeviceSignals then
		local v6 = { searchQuery = p2, sessionId = p3, globalSessionId = p4 }

		addSystemInfoToArgs(v6)

		return urlBuilder.addQueryString(v5(), v6)
	else
		local urlEncode = HttpService:UrlEncode(p2)
		local urlEncode2 = HttpService:UrlEncode(p3)
		local urlEncode3 = HttpService:UrlEncode(p4)

		return string.format(
			"%ssearch-api/v1/%s?searchQuery=%s&sessionId=%s&globalSessionId=%s",
			url.APIS_URL,
			fFlagLuaAppEnableSearchStreamingEndpoint and "search-results-page-stream" or "search-results-page",
			urlEncode,
			urlEncode2,
			urlEncode3
		)
	end
end

return getSearchResultsPageUrl
