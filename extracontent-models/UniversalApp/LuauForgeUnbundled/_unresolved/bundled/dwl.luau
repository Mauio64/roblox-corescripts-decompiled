local HttpService = game:GetService("HttpService")

local url = require("@luauforge/bundled/dus").Url
local addSystemInfoToArgs = require("@luauforge/bundled/dtM").AddSystemInfoToArgs

return function(callback, state)
	if state and state.searchQuery then
		state.searchQuery = HttpService:UrlEncode(state.searchQuery)
	elseif state and state.SearchQuery then
		state.SearchQuery = HttpService:UrlEncode(state.SearchQuery)
	end

	local APIS_URL = url.APIS_URL

	addSystemInfoToArgs(state)

	local queryString = url:makeQueryString(state)
	return callback(string.format("%ssearch-api/omni-search?%s", APIS_URL, queryString), "GET")
end
