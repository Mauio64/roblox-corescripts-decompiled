local url = require("@luauforge/bundled/fwo").Url
local urlBuilder = require("@luauforge/bundled/fwp").UrlBuilder
local addSystemInfoToArgs = require("@luauforge/bundled/fwm").AddSystemInfoToArgs

local v5 = urlBuilder.new({
	base = url.APIS_URL,
	path = "search-api/v1/search-results-page-stream"
})

local function getSearchResultsPageUrl(p2, p3, p4)
	local v6 = { searchQuery = p2, sessionId = p3, globalSessionId = p4 }

	addSystemInfoToArgs(v6)

	return urlBuilder.addQueryString(v5(), v6)
end

return getSearchResultsPageUrl
