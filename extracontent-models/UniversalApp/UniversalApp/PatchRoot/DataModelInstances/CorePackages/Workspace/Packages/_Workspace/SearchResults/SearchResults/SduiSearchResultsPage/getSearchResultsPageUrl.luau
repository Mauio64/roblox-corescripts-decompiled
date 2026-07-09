local Parent = script:FindFirstAncestor("SearchResults").Parent
local HttpService = game:GetService("HttpService")
local Url = require(Parent.Http).Url
local FFlagLuaAppEnableSearchStreamingEndpoint = require(Parent.SharedFlags).FFlagLuaAppEnableSearchStreamingEndpoint

local function getSearchResultsPageUrl(s1: string, s2: string, s3: string) -- line: 18
	-- upvalues: HttpService (copy), FFlagLuaAppEnableSearchStreamingEndpoint (copy), Url (copy)
	local v9 = HttpService:UrlEncode(s1)
	local v10 = HttpService:UrlEncode(s2)
	local v11 = HttpService:UrlEncode(s3)
	local v12 = not FFlagLuaAppEnableSearchStreamingEndpoint and "search-results-page" or "search-results-page-stream"

	return string.format("%ssearch-api/v1/%s?searchQuery=%s&sessionId=%s&globalSessionId=%s", Url.APIS_URL, v12, v9, v10, v11)
end

return getSearchResultsPageUrl
