local openSearchResultsWithQueryDeeplink = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics").Events.openSearchResultsWithQueryDeeplink

require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local openSearchResultsWithQueryParams = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Actions/openSearchResultsWithQueryParams")
local fFlagLuaAppSduiSearchAutocomplete = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiSearchAutocomplete

return function(p2, p3, p4)
	local searchQuery = openSearchResultsWithQueryParams.resolveSearchQuery(p2)
	local searchType = openSearchResultsWithQueryParams.resolveSearchType(p2)

	if
		searchQuery == nil
		or searchType == nil
		or fFlagLuaAppSduiSearchAutocomplete and openSearchResultsWithQueryParams.resolveIsAutocompleteSuggestion(p2)
	then
		return
	end

	openSearchResultsWithQueryDeeplink(p4.appPage, {
		kwd = searchQuery,
		searchType = searchType
	})
end
