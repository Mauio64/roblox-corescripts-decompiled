local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local openSearchResultsWithQueryDeeplink = DiscoveryAnalytics.Events.openSearchResultsWithQueryDeeplink

require(parent.SduiCoreSystem)
local openSearchResultsWithQueryParams = require(ServerDrivenUi.Actions.openSearchResultsWithQueryParams)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiSearchAutocomplete = SharedFlags.FFlagLuaAppSduiSearchAutocomplete

return function(p, _, p2)
	local searchQuery = openSearchResultsWithQueryParams.resolveSearchQuery(p)
	local searchType = openSearchResultsWithQueryParams.resolveSearchType(p)

	if
		searchQuery == nil
		or searchType == nil
		or FFlagLuaAppSduiSearchAutocomplete and openSearchResultsWithQueryParams.resolveIsAutocompleteSuggestion(p)
	then
		return
	end

	openSearchResultsWithQueryDeeplink(p2.appPage, { kwd = searchQuery, searchType = searchType })
end
